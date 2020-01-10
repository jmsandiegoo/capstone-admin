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

class AppointmentCommand extends UserCommand
{
    /**
     * @var string
     */
    protected $name = 'appointment';

    /**
     * @var string
     */
    protected $description = 'Enter Appointment System';

    /**
     * @var bool
     */
    protected $need_mysql = true;
    
    /**
     * @var string
     */
    protected $usage = '/appointment';

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
    public function execute()
    {
        $message = $this->getMessage();

        $chat_id = $message->getChat()->getId();
        $text    = 'Hi there!' . PHP_EOL . 'Welcome to Ngee Ann Polytechnic\'s School of ICT\'s Open House bot\'s Appointment System! Type /createAppt to join the queue!';

        $data = [
            'chat_id' => $chat_id,
            'text'    => $text,
        ];

        return Request::sendMessage($data);
    }
}
