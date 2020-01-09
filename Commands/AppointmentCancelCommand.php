<?php
/**
 * This file is part of the TelegramBot package.
 *
 * (c) Avtandil Kikabidze aka LONGMAN <akalongman@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

//namespace Longman\TelegramBot\Commands\UserCommands;
namespace Longman\TelegramBot\Commands\UserCommands;

use Longman\TelegramBot\DB;
use Longman\TelegramBot\Commands\Command;
use Longman\TelegramBot\Commands\UserCommand;
use Longman\TelegramBot\Conversation;
use Longman\TelegramBot\Entities\Keyboard;
use Longman\TelegramBot\Entities\KeyboardButton;
use Longman\TelegramBot\Entities\PhotoSize;
use Longman\TelegramBot\Request;

/**
 * User "/survey" command
 *
 * Command that demonstrated the Conversation funtionality in form of a simple survey.
 */
class cancelApptCommand extends UserCommand
{
    
    /**
     * @var string
     */
    protected $name = 'cancelAppt';

    /**
     * @var string
     */
    protected $description = 'cancelAppt for visitors';

    /**
     * @var string
     */
    protected $usage = '/cancelAppt';

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
    
    function check_status($user_id){
        $pdo = DB::getPdo(); if (! DB::isDbConnected()) {return false;}
        $sql = "SELECT appointment_status FROM `appointment` WHERE `user_id` =". $user_id ." AND `appointment_status` = 'Pending' OR 'Now Serving'";
        $sth = $pdo->prepare($sql);
        $sth->execute();
        $status = $sth->fetchAll(\PDO::FETCH_OBJ);
        $countstatus = count($status);
        if($countstatus>0){
            return true;
        }   
        else{
            return false;
        }
    }
    function cancel_queue($user_id){
        $pdo = DB::getPdo(); if (! DB::isDbConnected()) {return false;}
        $sql = "UPDATE `appointment` SET `appointment_status` = 'Cancelled' WHERE `user_id` =". $user_id;
        $sth = $pdo->prepare($sql);
        $sth->execute();
    }
    public function execute(){
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

        $return_status = $this->check_status($user_id);
        if($return_status==false){
            $data['text'] = 'You do not have a pending appointment. Please create an appointment at /createAppt if you would like to create one, thank you.';
            $result = Request::sendMessage($data);
        }
        else{
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
                
                // no break
                case 0:
                    if ($text === '' || !in_array($text, ['Yes','No'], true)) {
                        $notes['state'] = 0;
                        $this->conversation->update();

                        $data['reply_markup'] = (new Keyboard((['Yes','No'])))
                            ->setResizeKeyboard(true)
                            ->setOneTimeKeyboard(true)
                            ->setSelective(true);

                        $data['text'] = 'Are you sure you want to cancel your Appointment?:';
                        if ($text !== '') {
                            $data['text'] = 'Are you sure you want to cancel your Appointment, choose a keyboard option:';
                        }
                        
                        $result = Request::sendMessage($data);
                        break;
                    }
                    $notes['choice'] = $text;
                
                case 1:
                    $this->conversation->update();
                    //$out_text = '/CreateAppt result:' . PHP_EOL;
                    unset($notes['state']);
                    if ($notes['choice'] = 'Yes'){
                        //Cancel
                        $this->cancel_queue($user_id);
                        $data['text']      = "Your queue has been cancelled.";
                    }
                    else if ($notes['choice'] = 'No'){
                        //Send stop trolling message
                        $data['text']      = "Stop trolling la nabei";
                    }
                    $data['reply_markup'] = Keyboard::remove(['selective' => true]);
                    
                    $this->conversation->update();
                    $this->conversation->stop();
                    
                    
                    $result = Request::sendMessage($data);
                    break;
            }
        }
        return $result;
    }
}
