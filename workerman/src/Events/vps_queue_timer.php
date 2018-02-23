<?php
use Workerman\Connection\AsyncTcpConnection;

return function($stdObject) {
	global $global, $settings;
	$task_connection = new AsyncTcpConnection('Text://127.0.0.1:55552'); // Asynchronous link with the remote task service
	$task_connection->send(json_encode(array('function' => 'vps_queue', 'args' => $global->settings['vps_queue']['cmds']))); // send data
	$task_connection->onMessage = function($task_connection, $task_result) use ($task_connection) {	// get the result asynchronously
		 //var_dump($task_result);
		 $task_connection->close(); // remember to turn off the asynchronous link after getting the result
	};
	$task_connection->connect(); // execute async link
};