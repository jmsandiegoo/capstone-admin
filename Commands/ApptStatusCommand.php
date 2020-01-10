<?php
/**
 * This file is NOT part of the TelegramBot package.
 *
 * (c) Avtandil Kikabidze aka LONGMAN <akalongman@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace Longman\TelegramBot\Commands\UserCommands;

use Longman\TelegramBot\Commands\Command;
use Longman\TelegramBot\Commands\UserCommand;
use Longman\TelegramBot\Request;
use Longman\TelegramBot\DB;

class ApptStatusCommand extends UserCommand
{
    /**
     * @var string
     */
    protected $name = 'checkAppt';

    /**
     * @var string
     */
    protected $description = 'Check queue status';

    /**
     * @var string
     */
    protected $usage = '/checkAppt';

    /**
     * @var string
     */
    protected $version = '1.1.0';

    /**
     * @var bool
     */
    protected $private_only = true;

    /**
     * Command execute method
     *
     * @return \Longman\TelegramBot\Entities\ServerResponse
     * @throws \Longman\TelegramBot\Exception\TelegramException
     */
    function check_if_in_queue($user_id){
        $pdo = DB::getPdo(); if (! DB::isDbConnected()) {return false;}
        $sql = "SELECT appointment_status FROM `appointment` WHERE `user_id` =". $user_id ." AND `appointment_status` = 'Pending'";
        $sth = $pdo->prepare($sql);
        $sth->execute();
        $status = $sth->fetchAll(\PDO::FETCH_OBJ);
        $countstatus = count($status);
        return $countstatus;
    }
    function check_status($user_id){
        $pdo = DB::getPdo(); if (! DB::isDbConnected()) {return false;}
        $sql = "SELECT appointment_status FROM `appointment` WHERE `user_id` !=". $user_id ." AND `appointment_status` = 'Pending'";
        $sth = $pdo->prepare($sql);
        $sth->execute();
        $status = $sth->fetchAll(\PDO::FETCH_OBJ);
        $countstatus = count($status);
        return $countstatus;
    }
    public function execute()
    {
        $message = $this->getMessage();
        $chat_id = $message->getChat()->getId();
        $check_variable = $this->check_if_in_queue($chat_id);
        if ($check_variable == 0){
            $text = "You are not in the queue, /createAppt to create an appointment!";
        }
        else if ($check_variable > 0){
            $number = $this->check_status($chat_id);
            if ($number = 0){                
                $text = "You are next in line. Thank you for your patience.";
            }
            else if ($number = 1){
                $text = "There is ".$number." person in front of you. Thank you for your patience.";
            } 
            else if($number > 1){
                $text = "There are ".$number." people in front of you. Thank you for your patience.";
            }
        }
        $data = [
            'chat_id' => $chat_id,
            'text'    => $text,
        ];

        return Request::sendMessage($data);
    }
}
