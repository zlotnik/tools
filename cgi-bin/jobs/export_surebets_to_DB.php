<?php

//delete old data
$surebetsNodes = findAllSurebets('/var/www/cgi-bin/results/tmp/Poland_profitability.xml');
export_surebetsToDB( $surebetsNodes, '/var/www/data/surebets.db' );


function export_surebetsToDB( $surebetNodes, $pathToDB ) 
{
       // print_r($surebetNodes);
        
        foreach( $surebetNodes as $aSurebetNode )
        {
               export_aSurebetToDB( $aSurebetNode, $pathToDB ); 
        }

}


function export_aSurebetToDB( $surebetNode, $pathToDB )
{
        $insertQuery = 'insert into surebet_1X2 (homeTeam, price_1, profit ) values ';

        #name of fields can be inserted automaticly by key name
        //$insertQuery .= "('test', 1,". $surebetNode->profit . ")";
        
        //$db = new SQLite3($pathToDB);
        
        print_r ($surebetNode);
        //print_r ($insertQuery);
        exit;
        $results = $db->query($insertQuery);
        //print_r($results);
}




function findAllSurebets()
{
        $profitXml = simplexml_load_file('/var/www/cgi-bin/results/tmp/Poland_profitability.xml');

        $surebetNodes = array();

        foreach ($profitXml->xpath('//event') as $event_node)
        {
               //print_r($event_node ); 
                //echo $node_1X2->profit, PHP_EOL;
                if( $event_node->bestCombinations->_1X2->profit > 0 )
                {
                        //$surebetInfo = array( 'eventUrl' =>  string($event_node['url']);

                        $urlToEvent = (string)($event_node['url']);
                        $surebetInfo[$urlToEvent] = array( 'home' => 'Wiarusy'
                                                , 'visitor' => 'Clo'
                                                , 'date' => '2000.01.01'
                                                , '_1X2' =>  $event_node->bestCombinations->_1X2
                                                );




                        //print_r((string)$event_node['url']);
                        //exit;
                        //array_push( $surebetNodes, $node_1X2 );
                }
        }

        //print_r($surebetInfo);
        return $surebetInfo;
}


?>
