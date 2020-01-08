<?php

    use Longman\TelegramBot\Commands\Command;
    use Longman\TelegramBot\Commands\UserCommand;
    use Longman\TelegramBot\Request;
    
    require __DIR__. '/vendor/autoload.php';
    
    if(array_key_exists('button1', $_POST)) { 
        button1(); 
    } 

    function button1(){
        try {
            // Create Telegram API object
            $bot_api_key  = '976443852:AAGSd8gWovPo8jOjppg02GkoPpjWGi9B-cI';
            $bot_username = 'npictoh_bot';
            $telegram = new Longman\TelegramBot\Telegram($bot_api_key, $bot_username);

            // Enable MySQL
            //$telegram->enableMySql($mysql_credentials);
            $text    = 'kukubird';
            //get correct chat_id
            $chat_id = '450285215';
            $data = [
                'chat_id' => $chat_id,
                'text'    => $text,
            ];
        
            return Request::sendMessage($data);
        
        } catch (Longman\TelegramBot\Exception\TelegramException $e) {
            // log telegram errors
            // echo $e->getMessage();
        }
    }
?>
<!DOCTYPE html>
<html lang="en">
    <form method="post"> 
            <input type="submit" name="button1"
                    class="button" value="Button1" /> 
            
    </form> 
</html>