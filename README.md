# kdb-Apache

Kdb-Apache is an library that is able to convert kdb tables to and from the Apache Parquet table format. The library provides a translation of most common kdb primitive data types to Apache Parquet equivilent. The library provides similiar functionality to the library at https://github.com/rianoc/qParquet
, however the librray does not utilize the embedpy interface and potentially avoids an extra translation step when encoding and decoding files.

## Build Instructions

After cloning the repository from GitHub the package and examples can be built by executing cmake and then executing then make. The test folder contains a number of test scripts and a suite of unit tests has been supplied and discussed below. Please note that various standard utilities such as make and cmake are required. The package has been tested on vanillia Linux installs, though no reason exists why it cant be ported to other operating systems. 

## Examples
Simple examples are available in the test file supplied. Examples are supplied for reading, writing and inspecting parquet files anddemonstarted.

```
kdb@linux$ q q/examples.q
KDB+ 3.6 2020.02.14 Copyright (C) 1993-2020 Kx Systems
l64/ 4(16)core 15999MB **********************************************

"Parquet file reading examples"
============================================
Saving sample table: .pq.settabletofile[file;tab]
0i
Reading sample table: .pq.getfile[file]
j f d          s   
-------------------
1 3 2020.12.06 ,"a"
2 4 2020.12.06 ,"b"
3 5 2020.12.06 ,"c"
Inspecting sample table: .pq.getschema[file]
name type         
------------------
,"j" "int64"      
,"f" "double"     
,"d" "date32[day]"
,"s" "string"     
Reading subset of columns from file: .pq.getfilebycols[file;`j`f`d]
j f d         
--------------
1 3 2020.12.06
2 4 2020.12.06
3 5 2020.12.06
Streaming sample table: .pq.streamread[file]
code[`test.parquet]
============================================
 Good bye 
```
## Data type mappings ##

The parquet intrinsic types are mapped according to the table below when reading and writing to and from kdb+. In some cases assumptions have been made, especially when considering symbol data types andcertain temporal data types. Where possible `getfile` and `settabletofile` should encode and decode fields so that the functions are essentially the reciprocals of one another.   

|  Parquet Type  | kdb Type | Example |
| ------------- | ------------- | ------------|
| Timestamp(ms) | Timestamp     | 2001.01.01D12:01:01:01.000000|
| Date32(day)   | Date          | 2001.01.01                   |
| Time32        | Time          | 12:01:01.000                |
| Time64        | nyi           |    |
| int64         | Long          |          12|                  
| string        | array of characters||
| float32       | Float           |1.0|
| float64       | Float           |1.0|
| bool          | Boolean         |0b|
| uint16        | Int             |12i|
| uint32        | Long            |12|
| uint64        | Float           |12.3|
| decimal128    | nyi             ||
| binary        | nyi             ||
| Null          | 0h list         |()|



| Table Kdb Api Function | Description                   | Arguments            | Usage                                    | Example Usage                                     | 
|------------------------|-------------------------------|----------------------|------------------------------------------|---------------------------------------------------|
| Init                   | Initialize                    |                      |                                          |                                                   |  
| .pq.getproperties      |                               |                      |                                          |                                                   |   
| .pq.getschema          | shows columns and their types | &lt;filepath&gt;           | .pq.getschema[&lt;filepath&gt;]           |``.pq.getschema[`$"tests/testdata/simple_example.parquet"]``|   
| .pq.getfile            | retrieves table               | &lt;filepath&gt;           | .pq.getfile[&lt;filepath&gt;]             | ``.pq.getfile[`$"tests/testdata/simple_example.parquet"]`` |   
| .pq.getfilebycols      | retrives columns from tables  | &lt;filepath&gt; &lt;col_list&gt; | .pq.getfilebycols[&lt;filepath&gt;;&lt;col_list&gt;] |.pq.getfilebycols[getdatafile "simple_example.parquet";]       |
| .pq.settabletofile     | saves to a file               | &lt;filepath&gt;&lt;table&gt;| .pq.settabletofile[&lt;filepath&gt;;&lt;table&gt;] | `alltab:([]c:("h";"w");b:(1b;0b))` ``.pq.settabletofile[`here;alltab]`` |
| .pq.versioninfo        | shows build version and date  | no arguments         |                                          | .pq.versioninfo[]                                 |
| .pq.getfilebyindices   |                               |                      |                                          |                                                   |
|                        |                               |                      |                                          |                                                   |

Unit Tests are automated using the K4unit testing library from KX
https://github.com/simongarland/k4unit

Our tests are run using the master.q file which has 2 flags to indicate whether the user wishes the tests to be printed to the screen or not and which .pq namespace function to run unit tests for. The default is verbose:2 which prints the test to the screen and for all the tests to be run. 
q master.q -verbose "2" -file "getfile.csv"


```
17
2020.11.12T18:59:36.166 start
2020.11.12T18:59:36.166 :unit/getfile.csv 12 test(s)
q).pq.getfile[1]
\ts q)@[.pq.getfile;1;1b]
q)98h= type .pq.getfile getdatafile "test2.parquet"
num chunks is 1
q).pq.getfile[getdatafile "doesntexist"]
Could not get table schema
q)`error=@[.pq.getfile;getdatafile "doesntexist";{[x] `$x}]
Could not get table schema
q)2878=count .pq.getfile[getdatafile "test2.parquet"]
num chunks is 1
q)@[.pq.getfile; "info.txt";1b]
q).pq.getfile[``]
\ts q)timetab:([]time:.z.T+3?10;int: 1 2 3)
\ts q).pq.settabletofile[`there;timetab]
q)timetab~.pq.getfile[`there]
num chunks is 1
q).pq.getfile[`q]
Could not get table schema
2020.11.12T18:59:36.220 end
action ms bytes lang code                                                      repeat file              msx bytesx ok okms okbytes valid timestamp
----------------------------------------------------------------------------------------------------------------------------------------------------------------
fail   0  0     q    .pq.getfile[1]                                            1      :unit/getfile.csv 0   0      1  1    1       1     2020.11.12T18:59:36.166
run    0  0     q    @[.pq.getfile;1;1b]                                       1      :unit/getfile.csv 0   1024   1  1    1       1     2020.11.12T18:59:36.166
true   0  0     q    98h= type .pq.getfile getdatafile "test2.parquet"         1      :unit/getfile.csv 0   0      1  1    1       1     2020.11.12T18:59:36.208
fail   0  0     q    .pq.getfile[getdatafile "doesntexist"]                    1      :unit/getfile.csv 0   0      1  1    1       1     2020.11.12T18:59:36.208
true   0  0     q    `error=@[.pq.getfile;getdatafile "doesntexist";{[x] `$x}] 1      :unit/getfile.csv 0   0      1  1    1       1     2020.11.12T18:59:36.208
true   0  0     q    2878=count .pq.getfile[getdatafile "test2.parquet"]       1      :unit/getfile.csv 0   0      1  1    1       1     2020.11.12T18:59:36.218
true   0  0     q    @[.pq.getfile; "info.txt";1b]                             1      :unit/getfile.csv 0   0      1  1    1       1     2020.11.12T18:59:36.218
fail   0  0     q    .pq.getfile[``]                                           1      :unit/getfile.csv 0   0      1  1    1       1     2020.11.12T18:59:36.218
run    0  0     q    timetab:([]time:.z.T+3?10;int: 1 2 3)                     1      :unit/getfile.csv 0   2368   1  1    1       1     2020.11.12T18:59:36.218
run    0  0     q    .pq.settabletofile[`there;timetab]                        1      :unit/getfile.csv 0   0      0  1    1       0     2020.11.12T18:59:36.219
true   0  0     q    timetab~.pq.getfile[`there]                               1      :unit/getfile.csv 0   0      0  1    1       1     2020.11.12T18:59:36.220
fail   0  0     q    .pq.getfile[`q]                                           1      :unit/getfile.csv 0   0      1  1    1       1     2020.11.12T18:59:36.220
"#####################################"
" Failed Tests"
action ms bytes lang code                               repeat file              msx bytesx ok okms okbytes valid timestamp
-----------------------------------------------------------------------------------------------------------------------------------------
run    0  0     q    .pq.settabletofile[`there;timetab] 1      :unit/getfile.csv 0   0      0  1    1       0     2020.11.12T18:59:36.219
true   0  0     q    timetab~.pq.getfile[`there]        1      :unit/getfile.csv 0   0      0  1    1       1     2020.11.12T18:59:36.220
"#####################################"
q)
```
