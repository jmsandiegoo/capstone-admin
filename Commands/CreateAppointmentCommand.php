<?php

namespace Longman\TelegramBot\Commands\UserCommands;

use Longman\TelegramBot\DB;
use Longman\TelegramBot\Commands\Command;
use Longman\TelegramBot\Commands\UserCommand;
use Longman\TelegramBot\Conversation;
use Longman\TelegramBot\Entities\Keyboard;
use Longman\TelegramBot\Entities\KeyboardButton;
use Longman\TelegramBot\Entities\PhotoSize;
use Longman\TelegramBot\Request;

class createApptCommand extends UserCommand
{
    
    /**
     * @var string
     */
    protected $name = 'createAppt';

    /**
     * @var string
     */
    protected $description = 'createAppt for visitors';

    /**
     * @var string
     */
    protected $usage = '/createAppt';

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
    
    function get_course(){  
        $pdo = DB::getPdo(); if (! DB::isDbConnected()) {return false;}
        $sql = "SELECT id,course_abbreviations,course_name FROM course";
        $sth = $pdo->prepare($sql);
        $sth->execute();
        $courses = $sth->fetchAll(\PDO::FETCH_OBJ);
        $course_array = array();
        $course_id_array = array();
        $course_name_array = array();
        foreach ($courses as $obj)
        {
            array_push($course_array,$obj->course_abbreviations);
            $course_name_array[$obj->course_abbreviations] = $obj ->course_name;
            $course_id_array[$obj->course_name] = $obj->id;    
        }
        return array($course_id_array,$course_array,$course_name_array);   
    }

    function check_status($user_id){
        $pdo = DB::getPdo(); if (! DB::isDbConnected()) {return false;}
        $sql = "SELECT * FROM `appointment` WHERE DATE(appointment_createdate) = CURDATE() AND `user_id` = ". $user_id ." AND `appointment_status` = 'Pending' OR DATE(appointment_createdate) = CURDATE() AND `user_id` = ". $user_id ." AND `appointment_status` = 'Now Serving'";

        $sth = $pdo->prepare($sql);
        $sth->execute();
        $status = $sth->fetchAll(\PDO::FETCH_OBJ);

        $dates_array = [];
        foreach ($status as $obj)
        {
            $date_2 = $obj->appointment_createdate;
            array_push($dates_array,$date_2);
        }
        print_r($dates_array);

        $countstatus = count($status);
        if($countstatus>0){
            return true;
        }   
        else{
            return false;
        }
    }

    function save_result($notes){
        $return_array = $this->get_course();

        $date = date('Y-m-d H:i:s', time());

        $message = $this->getMessage();

        $chat    = $message->getChat();
        $user    = $message->getFrom();
        $chat_id = $chat->getId();
        $user_id = $user->getId();

        $pdo = DB::getPdo(); if (! DB::isDbConnected()) {return false;}
        $sql = "INSERT INTO appointment (`user_id`, `chat_id`, `is_general`, `appointment_name`, `appointment_status`, `course_id`, `phoneNumber`) 
        VALUES (:users_id, :chat_id, :is_general, :appointment_name, :appontment_status , :course_id, :phoneNumber)";
        
        if($notes['interest'] == 'General'){
            $is_general = 1;
            $db_courseid = NULL;
        }
        else{
            $is_general = 0;
            $db_courseid = $return_array[0][$notes['interest']];
        }

        $sth = $pdo->prepare($sql);
        $sth->bindValue(':users_id', $user_id);
        $sth->bindValue(':chat_id', $chat_id);
        $sth->bindValue(':is_general', $is_general);
        $sth->bindValue(':appointment_name', $notes['name']);
        $sth->bindValue(':appontment_status', 'Pending');
        $sth->bindValue(':course_id', $db_courseid);
        $sth->bindValue(':phoneNumber' ,$notes['phone_number']);
        
        $sth->execute();
    }
    public function execute(){
        $date = date('Y-m-d H:i:s', time());
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
        if($return_status==true){
            $data['text'] = 'You have a pending appointment. Please wait for your turn, thank you.';
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
                case 0:
                    if ($text === '') {
                        $notes['state'] = 0;
                        $this->conversation->update();

                        $data['text']         = 'Type your name:';
                        $data['reply_markup'] = Keyboard::remove(['selective' => true]);

                        $result = Request::sendMessage($data);
                        break;
                    }
                    
                    $notes['name'] = $text;
                    $text          = '';


                // no break
                case 1:
                    $return_array = $this->get_course();
                    $course_array_keyboard = $return_array[1];
                    array_push($course_array_keyboard,"General");
                    if ($text === '' || !in_array($text, $course_array_keyboard, true)) {
                        $notes['state'] = 1;
                        $this->conversation->update();

                        $data['reply_markup'] = (new Keyboard(($course_array_keyboard)))
                            ->setResizeKeyboard(true)
                            ->setOneTimeKeyboard(true)
                            ->setSelective(true);

                        $data['text'] = 'Select your Area of Interest:';
                        if ($text !== '') {
                            $data['text'] = 'Select your Area of Interest, choose a keyboard option:';
                        }
                        
                        $result = Request::sendMessage($data);
                        break;
                    }
                    if ($text != 'General'){
                        $notes['interest'] = $return_array[2][$text];
                    }
                    else{
                        $notes['interest'] = 'General';
                    }
                    
                // no break
                case 2:
                    if ($message->getContact() === null) {
                        $notes['state'] = 2;
                        $this->conversation->update();
                        $data['reply_markup'] = (new Keyboard((new KeyboardButton('Share Contact'))->setRequestContact(true)))
                            ->setOneTimeKeyboard(true)
                            ->setResizeKeyboard(true)
                            ->setSelective(true);

                        $data['text'] = 'We need your contact number to create an appointment. Please share your contact number. Your mobile number will only be used to contact you for appointment purposes.';
                        
                        $result = Request::sendMessage($data);
                        break;
                    }
                    $notes['phone_number'] = $message->getContact()->getPhoneNumber();
                
                // no break
                case 3:
                    $this->conversation->update();
                    $out_text = '';
                    unset($notes['state']);
                    foreach ($notes as $k => $v) {
                        $out_text .= PHP_EOL . ucfirst($k) . ': ' . $v;
                    }

                    $data['reply_markup'] = Keyboard::remove(['selective' => true]);
                    
                    $this->conversation->update();
                    $this->save_result($notes);    
                    $this->conversation->stop();
                    $pdo = DB::getPdo(); if (! DB::isDbConnected()) {return false;}
                    $sql = "SELECT appointment_id FROM `appointment` WHERE `user_id` =". $user_id;
                    $sth = $pdo->prepare($sql);
                    $sth->execute();
                    $queueno = $sth->fetchAll(\PDO::FETCH_OBJ);
                    $qno = '';
                    foreach ($queueno as $obj)
                    {
                        $qno = $obj->appointment_id;
                    }
                    $queue_text = "Queue Number: " . $qno;
                    $data['text']      = $queue_text. PHP_EOL .$out_text. PHP_EOL ."Please wait patiently and we will send you a telegram message when it is your turn.";

                    $result = Request::sendMessage($data);
                    break;
            }
        }
        return $result;
    }
}
