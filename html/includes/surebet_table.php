<?php 
function generateSurebetTable($surebetData_path)
{
	
    $surebetsData = file($surebetData_path);

    generateTable_Header();

    //generateTable_rows();
    
    foreach ($surebetsData as $line_num => $lineWithData) 
    {
        //echo "Line $line";
        generateSingle_table_row($lineWithData);
        // echo "Line #<b>{$line_num}</b> : " . htmlspecialchars($line) . "<br />\n";
    }

    generateTable_Footer();

};

function generateTable_Header()
{
    print <<< END
    <table id="box-table-b" summary="Surebets table">
    <thead>
        <tr>
            <th scope="col">Profit</th>
            <th scope="col">Discipline</th>
            <th scope="col">Event name</th>
            <th scope="col">Bookmaker 1</th>
            <th scope="col">Bookmaker 2</th>
            <th scope="col">Bookmaker 3</th>
            <th scope="col">Price 2</th>
            <th scope="col">Bookmaker 3</th>
            <th scope="col">Price 3</th>

        </tr>
    </thead>
    <tbody>
END;
};

function generateTable_Footer()
{
    echo '</tbody>';
    echo '</table>';
}


function generateTable_rows()
{
    print <<< END
        <tr align="center" >
            <td align="center"> 2.2</td>
            <td>Soccer</td>
            <td>Wisla Krakow - Cracovia Krakow</td>
            <td>bet365</td>
            <td>Marathon</td>
            <td>ComeOn</td>
            <td>40.3</td>
            <td>23.5</td>
            <td>40.3</td>
        </tr>
        <tr  align="center"  >
            <td>2.0</td>
            <td>Soccer</td>
            <td>Amica Wronki - Legia Warszawa</td>
            <td>Unibet</td>
            <td>William Hill</td>
            <td>Pinnacle</td>
            <td>39.3</td>
            <td>23.5</td>
            <td>40.3</td>

        </tr>
        <tr  align="center"  >
            <td>1.2</td>
            <td>Soccer</td>
            <td>Ruch Chorzow - Legia Warszawa</td>
            <td>Interwetten</td>
            <td>YouWin</td>
            <td>Marathon</td>
            <td>36.7</td>
            <td>23.5</td>
            <td>40.3</td>
        </tr>      
END;
}

function generateSingle_table_row($singleSurebetData)
{
    print '<tr align="center" >';
    
    
    preg_match('/EventName: (.*) PROFIT: (\d+\.\d+|\d+)/', $singleSurebetData, $matches);
    //preg_match('/EventName(.*)/', $singleSurebetData, $matches, PREG_OFFSET_CAPTURE);
    $eventName = $matches[1];
    $profit = $matches[2];
    print_r($matches);
    //print $singleSurebetData . "END";
    //print $profit;
    //exit();

    print '<td align="center">' . $profit . '</td>';
    print "<td>Soccer</td>";
    print "<td>$eventName</td>";
    print "<td>TODO</td>";
    print "<td>TODO</td>";
    print "<td>ComeOn</td>";
    print "<td>40.3</td>";
    print "<td>23.5</td>";
    print "<td>40.3</td>";
    print "</tr>";

}
?>
