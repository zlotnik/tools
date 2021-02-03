<?php

//delete old data
$surebetsNodes = findAllSurebets('/var/www/cgi-bin/results/tmp/Poland_profitability.xml');
print_r($surebetsNodes);
export_surebetsToDB( $surebetsNodes, '/var/www/data/surebets.db' );


function export_surebetsToDB( $surebetNodes, $pathToDB ) 
{

        foreach( $surebetNodes as $aSurebetNode )
        {
               export_aSurebetToDB( $aSurebetNode, $pathToDB ); 
        }

}


function export_aSurebetToDB( $surebetNode, $pathToDB )
{
        $insertQuery = 'insert into surebet_1X2 (homeTeam, price_1, profit ) values ';

        $insertQuery .= "('test', 1,". $surebetNode->profit . ")";
        
        $db = new SQLite3($pathToDB);
        
        print_r ($insertQuery);
        $results = $db->query($insertQuery);
        print_r($results);
}




function findAllSurebets()
{
        $profitXml = simplexml_load_file('/var/www/cgi-bin/results/tmp/Poland_profitability.xml');

        $surebetNodes = array();

        foreach ($profitXml->xpath('//_1X2') as $node_1X2)
        {
                //echo $node_1X2->profit, PHP_EOL;
                if( $node_1X2->profit > 0 )
                {
                        array_push( $surebetNodes, $node_1X2 );
                }
        }

        return $surebetNodes;

}


?>
