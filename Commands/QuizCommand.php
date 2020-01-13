<?php
/**
 * This file is part of the TelegramBot package.
 *
 * (c) Avtandil Kikabidze aka LONGMAN <akalongman@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace Longman\TelegramBot\Commands\UserCommands;

use Longman\TelegramBot\Commands\UserCommand;
use Longman\TelegramBot\Conversation;
use Longman\TelegramBot\Entities\Keyboard;
use Longman\TelegramBot\Entities\KeyboardButton;
use Longman\TelegramBot\Entities\PhotoSize;
use Longman\TelegramBot\Request;

/**
 * User "/quiz" command
 *
 * Command that demonstrated the Conversation funtionality in form of a simple quiz.
 */
class QuizCommand extends UserCommand
{
    /**
     * @var string
     */
    protected $name = 'quiz';

    /**
     * @var string
     */
    protected $description = 'Take a quiz of 9 questions for course recommendations.';

    /**
     * @var string
     */
    protected $usage = '/quiz';

    /**
     * @var string
     */
    protected $version = '0.3.0';

    /**
     * @var bool
     */
    protected $need_mysql = true;

    /**
     * @var bool
     */
    protected $private_only = true;

    /**
     * Conversation Object
     *
     * @var \Longman\TelegramBot\Conversation
     */
    protected $conversation;

    /**
     * Command execute method
     *
     * @return \Longman\TelegramBot\Entities\ServerResponse
     * @throws \Longman\TelegramBot\Exception\TelegramException
     */
    public function execute()
    {
        $message = $this->getMessage();

        $chat    = $message->getChat();
        $user    = $message->getFrom();
        $text    = trim($message->getText(true));
        $chat_id = $chat->getId();
        $user_id = $user->getId();

        //Preparing Response
        $data = [
            'chat_id' => $chat_id,
        ];

        if ($chat->isGroupChat() || $chat->isSuperGroup()) {
            //reply to message id is applied by default
            //Force reply is applied by default so it can work with privacy on
            $data['reply_markup'] = Keyboard::forceReply(['selective' => true]);
        }

        //Conversation start
        $this->conversation = new Conversation($user_id, $chat_id, $this->getName());

        $notes = &$this->conversation->notes;
        !is_array($notes) && $notes = [];

        //cache data from the tracking session if any
        $state = 0;
        if (isset($notes['state'])) {
            $state = $notes['state'];
        }

        $result = Request::emptyResponse();

        //State machine
        //Entrypoint of the machine state if given by the track
        //Every time a step is achieved the track is updated
        switch ($state) {
            case 0:
                if ($text === '' || !in_array($text, ['Hands-on', 'Theory-based',"I'm not sure"], true)) {
                    $notes['state'] = 0;
                    $this->conversation->update();

                    $data['reply_markup'] = (new Keyboard(['Hands-on', 'Theory-based',"I'm not sure"]))
                        ->setResizeKeyboard(true)
                        ->setOneTimeKeyboard(true)
                        ->setSelective(true);

                    $data['text'] = '1. Do you prefer to be more hands-on or theory-based?';
                    if ($text !== '') {
                        $data['text'] = 'Select your answer by choosing a keyboard option.' . PHP_EOL.
                        'If options are not available, please click on the icon beside the microphone.';
                    }
                    $result = Request::sendMessage($data);
                    break;
                }
                if ($text == 'Hands-on')
                {
                    $notes['IT'] += 1;
                    $notes['IM'] += 1;
                    $notes['CICT'] += 1;
                }
                else if ($text == 'Theory-based')
                {
                    $notes['FI'] += 1;
                    $notes['CDF'] += 1;
                }
                else if ($text == "I'm not sure")
                {
                    $notes['IT'] += -1;
                    $notes['FI'] += -1;
                    $notes['IM'] += -1;
                    $notes['CDF'] += -1;
                    $notes['CICT'] += -1;
                }
                $text = '';
            case 1:
                if ($text === '' || !in_array($text, ['A','B','C','D','E'], true)) {
                    $notes['state'] = 1;
                    $this->conversation->update();

                    $data['reply_markup'] = (new Keyboard(['A','B','C','D','E']))
                        ->setResizeKeyboard(true)
                        ->setOneTimeKeyboard(true)
                        ->setSelective(true);

                    $data['text'] = '2. Which of the following sounds more interesting to you?' . PHP_EOL.
                    'a.	Application development' . PHP_EOL.
                    'b.	Photoshop and animations' . PHP_EOL.
                    'c.	Enterprise and business planning' . PHP_EOL.
                    'd.	Networking and cloud management' . PHP_EOL.
                    'e.	I’m not sure';
                    if ($text !== '') {
                        $data['text'] = 'Select your answer by choosing a keyboard option.' . PHP_EOL.
                        'If options are not available, please click on the icon beside the microphone.';
                    }
                    $result = Request::sendMessage($data);
                    break;
                }
                if ($text == 'A')
                {
                    $notes['IT'] += 1;
                }
                else if ($text == 'B')
                {
                    $notes['IM'] += 1;
                }
                else if ($text == 'C')
                {
                    $notes['FI'] += 1;
                }
                else if ($text == 'D')
                {
                    $notes['CDF'] += 1;
                }
                else if ($text == 'E')
                {
                    $notes['IT'] += -1;
                    $notes['FI'] += -1;
                    $notes['IM'] += -1;
                    $notes['CDF'] += -1;
                    $notes['CICT'] += -1;
                }
                $text = '';
            case 2:
                if ($text === '' || !in_array($text, ['A', 'B','C','D','E'], true)) {
                    $notes['state'] = 2;
                    $this->conversation->update();

                    $data['reply_markup'] = (new Keyboard(['A','B','C','D','E']))
                        ->setResizeKeyboard(true)
                        ->setOneTimeKeyboard(true)
                        ->setSelective(true);

                    $data['text'] = '3. Which of the following sounds more interesting to you?' . PHP_EOL.
                    'a.	Creating a website' . PHP_EOL.
                    'b.	Data charts and visualizations' . PHP_EOL.
                    'c.	3D animation modeling' . PHP_EOL.
                    'd.	Networking security testing and protection' . PHP_EOL.
                    'e.	I’m not sure';
                    if ($text !== '') {
                        $data['text'] = 'Select your answer by choosing a keyboard option.' . PHP_EOL.
                        'If options are not available, please click on the icon beside the microphone.';
                    }
                    $result = Request::sendMessage($data);
                    break;
                }
                
                if ($text == 'A')
                {
                    $notes['IT'] += 1;
                }
                else if ($text == 'B')
                {
                    $notes['FI'] += 1;
                }
                else if ($text == 'C')
                {
                    $notes['IM'] += 1;
                }
                else if ($text == 'D')
                {
                    $notes['CDF'] += 1;
                }
                else if ($text == 'E')
                {
                    $notes['IT'] += -1;
                    $notes['FI'] += -1;
                    $notes['IM'] += -1;
                    $notes['CDF'] += -1;
                    $notes['CICT'] += -1;
                }   
                $text = '';
            case 3:
                if ($text === '' || !in_array($text, ['Yes', 'No'], true)) {
                    $notes['state'] = 3;
                    $this->conversation->update();

                    $data['reply_markup'] = (new Keyboard(['Yes', 'No']))
                        ->setResizeKeyboard(true)
                        ->setOneTimeKeyboard(true)
                        ->setSelective(true);

                    $data['text'] = '4. I believe that I am a very creative individual.';
                    if ($text !== '') {
                        $data['text'] = 'Select your answer by choosing a keyboard option.' . PHP_EOL.
                        'If options are not available, please click on the icon beside the microphone.';
                    }
                    $result = Request::sendMessage($data);
                    break;
                }

                if ($text == 'Yes')
                {
                    $notes['IT'] += 1;
                    $notes['IM'] += 1;
                    $notes['CICT'] += 1;
                }
                else if ($text == 'No')
                {
                    $notes['FI'] += 1;
                    $notes['CDF'] += 1;
                }
                $text = '';

            case 4:
                if ($text === '' || !in_array($text, ['Yes', 'No'], true)) {
                    $notes['state'] = 4;
                    $this->conversation->update();

                    $data['reply_markup'] = (new Keyboard(['Yes', 'No']))
                        ->setResizeKeyboard(true)
                        ->setOneTimeKeyboard(true)
                        ->setSelective(true);

                    $data['text'] = '5. I have a strong interest in designs and animations.';
                    if ($text !== '') {
                        $data['text'] = 'Select your answer by choosing a keyboard option.' . PHP_EOL.
                        'If options are not available, please click on the icon beside the microphone.';
                    }
                    $result = Request::sendMessage($data);
                    break;
                }
                if ($text == 'Yes')
                {
                    $notes['IM'] += 1;
                }
                $text = '';
                
            case 5:
                if ($text === '' || !in_array($text, ['Yes', 'No'], true)) {
                    $notes['state'] = 5;
                    $this->conversation->update();

                    $data['reply_markup'] = (new Keyboard(['Yes', 'No']))
                        ->setResizeKeyboard(true)
                        ->setOneTimeKeyboard(true)
                        ->setSelective(true);

                    $data['text'] = '6. I have a strong interest in web and applications design.';
                    if ($text !== '') {
                        $data['text'] = 'Select your answer by choosing a keyboard option.' . PHP_EOL.
                        'If options are not available, please click on the icon beside the microphone.';
                    }
                    $result = Request::sendMessage($data);
                    break;
                }
                if ($text == 'Yes')
                {
                    $notes['IT'] += 1;
                }
                $text = '';

            case 6:
                if ($text === '' || !in_array($text, ['Yes', 'No'], true)) {
                    $notes['state'] = 6;
                    $this->conversation->update();

                    $data['reply_markup'] = (new Keyboard(['Yes', 'No']))
                        ->setResizeKeyboard(true)
                        ->setOneTimeKeyboard(true)
                        ->setSelective(true);

                    $data['text'] = '7. I have a strong interest in understanding how networks and cloud applications work.';
                    if ($text !== '') {
                        $data['text'] = 'Select your answer by choosing a keyboard option.' . PHP_EOL.
                        'If options are not available, please click on the icon beside the microphone.';
                    }
                    $result = Request::sendMessage($data);
                    break;
                }
                if ($text == 'Yes')
                {
                    $notes['CDF'] += 1;
                }
                $text = '';
            case 7:
                if ($text === '' || !in_array($text, ['Yes', 'No'], true)) {
                    $notes['state'] = 7;
                    $this->conversation->update();

                    $data['reply_markup'] = (new Keyboard(['Yes', 'No']))
                        ->setResizeKeyboard(true)
                        ->setOneTimeKeyboard(true)
                        ->setSelective(true);

                    $data['text'] = '8. I have a strong interest in analyzing business data and processes.';
                    if ($text !== '') {
                        $data['text'] = 'Select your answer by choosing a keyboard option.' . PHP_EOL.
                        'If options are not available, please click on the icon beside the microphone.';
                    }
                    $result = Request::sendMessage($data);
                    break;
                }
                if ($text == 'Yes')
                {
                    $notes['FI'] += 1;
                }
                $text = '';
                // no break  
            case 8:
                if ($text === '' || !in_array($text, ['Agree', 'Disagree'], true)) {
                    $notes['state'] = 8;
                    $this->conversation->update();

                    $data['reply_markup'] = (new Keyboard(['Agree', 'Disagree']))
                        ->setResizeKeyboard(true)
                        ->setOneTimeKeyboard(true)
                        ->setSelective(true);

                    $data['text'] = '9. I am very interested in joining the IT industry when I come out to work.';
                    if ($text !== '') {
                        $data['text'] = 'Select your answer by choosing a keyboard option.' . PHP_EOL.
                        'If options are not available, please click on the icon beside the microphone.';
                    }
                    $result = Request::sendMessage($data);
                    break;
                }
                if ($text == 'Disagree')
                {
                    $notes['IT'] = 0;
                    $notes['FI'] = 0;
                    $notes['IM'] = 0;
                    $notes['CDF'] = 0;
                    $notes['CICT'] = 0;
                }
                $text = '';
            case 9:
                $this->conversation->update();
                $out_text = '/quiz result:' . PHP_EOL . 
                'Higher points indicates a stronger interest in the course.' . PHP_EOL .
                'IT: Information Technology' . PHP_EOL .
                'FI: Financial Informatics' . PHP_EOL .
                'IM: Immersive Media' . PHP_EOL .
                'CDF: Cybersecurity & Digital Forensics' . PHP_EOL .
                'CICT: Common ICT Programme' . PHP_EOL;
                unset($notes['state']);
                
                if($notes['IT'] == 0 && $notes['FI'] == 0 && $notes['IM'] == 0 && $notes['CDF'] == 0 && $notes['CICT'] == 0)
                {
                    $out_text = '/quiz result:' . PHP_EOL . 
                    'You have not shown enough interest in our courses through our quiz, it might be better for you to choose a course outside of School of ICT' . PHP_EOL;
                }

                foreach ($notes as $k => $v) {
                    $out_text .= PHP_EOL . ucfirst($k) . ': ' . $v;
                }
                $data['reply_markup'] = Keyboard::remove(['selective' => true]);
                $data['text']      = $out_text;
                $this->conversation->stop();

                $result = Request::sendMessage($data);
                break;        
        }

        return $result;
    }
}
