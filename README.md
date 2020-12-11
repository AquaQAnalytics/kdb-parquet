# kdb-Apache

Kdb-Apache is an library that is able to convert kdb tables to and from the Apache Parquet table format. The library provides a translation of most common kdb primitive data types to Apache Parquet equivilent and vice versa. The codebase provides similiar functionality to the library [here](https://github.com/rianoc/qParquet), however the library does not utilize the embedpy interface and potentially avoids an extra translation step when encoding and decoding files.

## Build Instructions

First step is to clone the TorQ-Quanthouse repository as shown below.

`mstranger@homer:~$ git clone https://github.com/AquaQAnalytics/kdb-Apache`

After cloning the repository from GitHub the package and examples can be built by executing cmake and then executing then make. The test folder contains a number of test scripts and a suite of unit tests has been supplied and discussed below. Please note that various standard utilities such as make and cmake are required. The package has been tested on vanillia Linux installs, though no reason exists why it cant be ported to other operating systems.


`mstranger@homer:~/kdb-Apache$ cmake .`

-- Configuring done

-- Generating done

-- Build files have been written to: /home/mstranger/kdb-Apache

`mstranger@homer:~/kdb-Apache$ make`

[100%] Built target PQ

 

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

## Api Usage Table

| Table Kdb Api Function | Description                   | Arguments            | Example Usage                            | 
|------------------------|-------------------------------|----------------------|------------------------------------------|
| Init                   | Initialize                    |                      |                                          | 
| .pq.getproperties      |                               |                      |                                          | 
| .pq.getschema          | shows columns and their types | &lt;filepath&gt;     | ``.pq.getschema[`simple_example.parquet]``|   
| .pq.getfile            | retrieves table               | &lt;filepath&gt;           |  ``.pq.getfile[`simple_example.parquet]`` |   
| .pq.getfilebycols      | retrives columns from tables  | &lt;filepath&gt; &lt;col_list&gt; |``.pq.getfilebycols[`simple_example.parquet;`cols1`col2]``|
| .pq.settabletofile     | saves to a file               | &lt;filepath&gt;&lt;table&gt;|  ``.pq.settabletofile[`here;([]a:1 2 3;b:3 4 5)]`` |
| .pq.versioninfo        | shows build version and date  |         |               `.pq.versioninfo[]`                                 |
| .pq.streamread         |                               |                      |                                          |




## Unit Testing
Unit Tests are automated using the K4unit testing library from KX
Our tests are run using the master.q file which has 2 flags to indicate whether the user wishes the tests to be printed to the screen or not and which .pq namespace function to run unit tests for. The default is verbose:2 which prints the test to the screen and for all the tests to be run. 

```
mstranger@homer:~/kdb-Apache/k4unit$ q master.q -file getfile.csv -verbose 1
KDB+ 4.0 2020.07.15 Copyright (C) 1993-2020 Kx Systems
l64/ 24()core 128387MB mstranger homer 127.0.1.1 EXPIRE 2021.06.30 AquaQ #59946

`.pq
24
2020.12.11T09:27:00.682 start
2020.12.11T09:27:00.682 :unit/getfile.csv 20 test(s)
Could not get table schema
Could not get table schema
Could not get table schema
Could not get table schema
2020.12.11T09:27:00.712 end
action ms bytes lang code                                                                   repeat file              msx bytesx ok okms okbytes valid timestamp 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fail   0  0     q    .pq.getfile[1]                                                         1      :unit/getfile.csv 0   0      1  1    1       1     2020.12.11T09:27:00.682
fail   0  0     q    .pq.getfile[`q]                                                        1      :unit/getfile.csv 0   0      1  1    1       1     2020.12.11T09:27:00.683
fail   0  0     q    .pq.getfile["q" 1]                                                     1      :unit/getfile.csv 0   0      1  1    1       1     2020.12.11T09:27:00.683
run    0  0     q    @[.pq.getfile;1;1b]                                                    1      :unit/getfile.csv 0   1024   1  1    1       1     2020.12.11T09:27:00.683
true   0  0     q    98h= type .pq.getfile getdatafile "test2.parquet"                      1      :unit/getfile.csv 0   0      1  1    1       1     2020.12.11T09:27:00.696
fail   0  0     q    .pq.getfile[getdatafile "doesntexist.parquet"]                         1      :unit/getfile.csv 0   0      1  1    1       1     2020.12.11T09:27:00.696
true   0  0     q    `error=@[.pq.getfile;getdatafile "doesntexist.parquet";{[x] `$x}]      1      :unit/getfile.csv 0   0      1  1    1       1     2020.12.11T09:27:00.696
fail   0  0     q    .pq.getfile[getdatafile "info.txt"]                                    1      :unit/getfile.csv 0   0      1  1    1       1     2020.12.11T09:27:00.697
true   0  0     q    2878=count .pq.getfile[getdatafile "test2.parquet"]                    1      :unit/getfile.csv 0   0      1  1    1       1     2020.12.11T09:27:00.706
true   0  0     q    @[.pq.getfile; "info.txt";1b]                                          1      :unit/getfile.csv 0   0      1  1    1       1     2020.12.11T09:27:00.706
fail   0  0     q    .pq.getfile[``]                                                        1      :unit/getfile.csv 0   0      1  1    1       1     2020.12.11T09:27:00.706
true   0  0     q    `argtype=@[.pq.getfile;``;{[x] `$x}]                                   1      :unit/getfile.csv 0   0      1  1    1       1     2020.12.11T09:27:00.706
run    0  0     q    timetab:([]time:.z.T+3?10;int: 1 2 3)                                  1      :unit/getfile.csv 0   2368   1  1    1       1     2020.12.11T09:27:00.706
run    0  0     q    .pq.settabletofile[`there;timetab]                                     1      :unit/getfile.csv 1   928    1  1    1       1     2020.12.11T09:27:00.707
true   0  0     q    timetab~.pq.getfile[`there]                                            1      :unit/getfile.csv 0   0      1  1    1       1     2020.12.11T09:27:00.708
run    0  0     q    nulltab:([]f:(0n;0n); j:(0Nj;0Nj);i:(0Ni;0Ni);t:(0Nt;0Nt);c:(" ";" ")) 1      :unit/getfile.csv 0   4352   1  1    1       1     2020.12.11T09:27:00.708
run    0  0     q    .pq.settabletofile[`here;nulltab]                                      1      :unit/getfile.csv 1   928    1  1    1       1     2020.12.11T09:27:00.710
true   0  0     q    nulltab~.pq.getfile[`here]                                             1      :unit/getfile.csv 0   0      0  1    1       1     2020.12.11T09:27:00.712
run    0  0     q    hdel `:here                                                            1      :unit/getfile.csv 0   528    1  1    1       1     2020.12.11T09:27:00.712
run    0  0     q    hdel `:there                                                           1      :unit/getfile.csv 0   528    1  1    1       1     2020.12.11T09:27:00.712
"#####################################"
" Failed Tests"
action ms bytes lang code                       repeat file              msx bytesx ok okms okbytes valid timestamp
---------------------------------------------------------------------------------------------------------------------------------
true   0  0     q    nulltab~.pq.getfile[`here] 1      :unit/getfile.csv 0   0      0  1    1       1     2020.12.11T09:27:00.712
"#####################################"
```

## Comparison to EmbedPy interface
The embedPy interface ( add  a link) is a flexiable APi that allows python and kdb+ to share memory and interact with each another. In theory the universe of functionality available within python is opened up to kdb+. However this flexability does come at a certain cost when it comes to performance. In the example below we create a simple parquet file with 1 million rows and a small number of columns and import this file into kdb+ via the embedpy interface and for comparison directly via the functionality available in this repository. It can be clearly seen example the translation of data into python and then subsequently to kdb+ has a large overhead, with the import being twice as slow. When working interactively with kdb+ this may not be an issue, however when speed is an issue for applications such as EOD exports from an external system this may be an important factor. Furthermore, the number of temporal variables supported natively, rather than needing special transformations when involving embedpy may be important. With that said the embedpy suite has a number of other features that make it generally a moreuseful tool. This example is mentto highlight the improvements that can be made by writing a custom application in this specific instance.  

## Future Work

The next stage of this interface will be to potentially explore the possibility of allowing multiple kdb+ sessions to share data via the in-memory arrow format and a shared memory segment. In effect large tables would be loaded into one shared memory segment and made accessible via multiple different applications, potentially with the arrow table being appended to from a master process. For certain applications this could remove the need for IPC communication when operating on data sets and potentially reduce overall memory usage of the system as a whole. The actual practicalities of this design have not yet been considered.  



