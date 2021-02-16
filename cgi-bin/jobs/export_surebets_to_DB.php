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


function export_aSurebetToDB( $surebetInfo, $pathToDB )
{
        $insertQuery = 'insert into Surebets_1X2 (profit, homeTeam, visitingTeam, bookmaker_1, bookmaker_X, bookmaker_2, price_1, price_X, price_2) values ';

        //print_r( $surebetInfo );
        #name of fields can be inserted automaticly by key name
        $homeTeam = $surebetInfo['home'];

        $visitingTeam = $surebetInfo['visitor'];
        $bookmaker_1 = ($surebetInfo['_1X2']->_1->children()[0]->getName()) ; 
        $bookmaker_X = ($surebetInfo['_1X2']->_X->children()[0]->getName()) ; 
        $bookmaker_2 = ($surebetInfo['_1X2']->_2->children()[0]->getName()) ; 
        $price_1 = $surebetInfo['_1X2']->_1->$bookmaker_1;
        $price_X = $surebetInfo['_1X2']->_X->$bookmaker_X;
        $price_2 = $surebetInfo['_1X2']->_2->$bookmaker_2;
        $profit =  $surebetInfo['_1X2']->profit;


        $insertQueryValues = sprintf( '(%f, "%s", "%s", "%s", "%s", "%s", %f, %f, %f );', $profit, $homeTeam, $visitingTeam, $bookmaker_1, $bookmaker_X, $bookmaker_2, $price_1, $price_X, $price_2 );
       
        $insertQuery .= $insertQueryValues;

        print_r ($insertQuery);
        $db = new SQLite3($pathToDB);
        //print_r ($surebetNode);
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
