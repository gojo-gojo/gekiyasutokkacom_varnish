<?php

// $xml_string = file_get_contents('./test.xml');
$xml_string = file_get_contents('https://gekiyasutokka.com/feed/');
$xml = new DOMDocument();
$xml->loadXML($xml_string);
$xpath = new DOMXPath($xml);
$pubDate = $xpath->query('//channel/item[1]/pubDate')->item(0)->nodeValue;
// print_r($pubDate);

$current_time = time();
$pubDate_time = strtotime($pubDate);
$time_diff_sec = $current_time - $pubDate_time;

print_r("{$time_diff_sec}sec");
