 #import "SQLViewController.h"
 #import <sqlite3.h>
 @interface SQLViewController ()
   //db是数据库的句柄，就是数据库的象征，要对数据库进行增删改查，就得操作这个实例
 @property(nonatomic,assign)sqlite3 *db;
 - (IBAction)insert;
 - (IBAction)delete;
 - (IBAction)update;
 - (IBAction)select;

@end

// 参考  http://blog.csdn.net/naturebe/article/details/7002801

@implementation SQLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
     //    sqlite3 *db;
    
        //获得数据库文件的路径
         NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fileName=[doc stringByAppendingPathComponent:@"students.sqlite"];
         //将OC字符串转换为c语言的字符串
         const char *cfileName=fileName.UTF8String;
    
         //1.打开数据库文件（如果数据库文件不存在，那么该函数会自动创建数据库文件）
         int result = sqlite3_open(cfileName, &_db);
         if (result==SQLITE_OK) {        //打开成功
                 NSLog(@"成功打开数据库");
        
            //2.创建表
                 const char  *sql="CREATE TABLE  t_students (id integer PRIMARY KEY AUTOINCREMENT,name text NOT NULL,age integer NOT NULL);";
                 char *errmsg=NULL;
                 result = sqlite3_exec(self.db, sql, NULL, NULL, &errmsg);
                 if (result==SQLITE_OK) {
                         NSLog(@"创表成功");
                     }else
                         {
                     //   NSLog(@"创表失败----%s",errmsg);
                    printf("创表失败---%s----%s---%d",errmsg,__FILE__,__LINE__);
                             }
             }else{NSLog(@"打开数据库失败");}
}

- (IBAction)insert {
         for (int i=0; i<20; i++) {
                 //1.拼接SQL语句
                 NSString *name=[NSString stringWithFormat:@"文晓--%d",arc4random_uniform(100)];
                 int age=arc4random_uniform(20)+10;
                 NSString *sql=[NSString stringWithFormat:@"INSERT INTO t_students (name,age) VALUES ('%@',%d);",name,age];
               //2.执行SQL语句
               char *errmsg=NULL;
                sqlite3_exec(self.db, sql.UTF8String, NULL, NULL, &errmsg);
                 if (errmsg) {//如果有错误信息
                        NSLog(@"插入数据失败--%s",errmsg);
                     }else{      NSLog(@"插入数据成功"); }
             }
}

- (IBAction)delete {


}

-(IBAction)update{

    
    
}

- (IBAction)select {
         const char *sql="SELECT id,name,age FROM t_students WHERE age<20;";
         sqlite3_stmt *stmt=NULL;
    
         //进行查询前的准备工作
         if (sqlite3_prepare_v2(self.db, sql, -1, &stmt, NULL)==SQLITE_OK) {//SQL语句没有问题
            NSLog(@"查询语句没有问题");
                 //每调用一次sqlite3_step函数，stmt就会指向下一条记录
                 while (sqlite3_step(stmt)==SQLITE_ROW) {//找到一条记录
                         //取出数据
                         //(1)取出第0列字段的值（int类型的值）
                         int ID=sqlite3_column_int(stmt, 0);
                         //(2)取出第1列字段的值（text类型的值）
                         const unsigned char *name=sqlite3_column_text(stmt, 1);
                        //(3)取出第2列字段的值（int类型的值）
                         int age=sqlite3_column_int(stmt, 2);
             //            NSLog(@"%d %s %d",ID,name,age);
                        printf("%d %s %d\n",ID,name,age);
                     }
             }else{       NSLog(@"查询语句有问题"); }
}

- (IBAction)selectWithCallBck:(id)sender {
    const char *sql="SELECT id,name,age FROM t_students WHERE age<20;";
    char *errmsg = NULL;
    
    sqlite3_exec(self.db, sql, LoadMyInfo, NULL, &errmsg);

}


typedef int (*sqlite3_callback)( void *, int , char **, char **);
/**
 *  查询的回调 这个回调在查询到的每一列都会调用一次
 *
 *  @param para
 *  @param n_column     查询结果列的总数
 *  @param column_value 字段名
 *  @param column_name  字段值
 *
 *  @return
 */
sqlite3_callback LoadMyInfo( void * para, int n_column, char ** column_value, char ** column_name )
{
    
    int i;
    printf( "记录包含 %d 个字段\n ", n_column );
    
    for( i = 0 ; i < n_column; i ++ )
        printf( "字段名:%s ß > 字段值:%s\n " , column_name[i], column_value[i] );
    printf( " ------------------\n " );
    return 0;
    
    
    
    //正常情况下，回调函数应该返回0，如果它返回一个非0值，则sqlite3_exec函数将终止执行，并返回SQLITE_ABORT错误码。
}




- (IBAction)selectWithGetTable:(id)sender{
    
    int result;
    
    char * errmsg = NULL;
    
    char **dbResult; // 是 char ** 类型，两个* 号  指针的指针
    
    int nRow, nColumn;
    
    int i , j;
    
    int index;
      const char *sql="SELECT id,name,age FROM t_students WHERE age<20;";
    
    // 数据库操作代码
    
    // 假设前面已经创建了 MyTable_1 表
    
    // 开始查询，传入的 dbResult 已经是 char ** ，这里又加了一个 & 取地址符，传递进去的就成了 char ***
    /**
     *
     *
     *  @param self.db  数据库
     *  @param sql      sql 语句，跟 sqlite3_exec 里的 sql 是一样的。是一个很普通的以 \0 结尾的 char * 字符串
     *  @param dbResult 查询结果，它依然一维数组（不要以为是二维数组，更不要以为是三维数组）。它内存布局是：第一行是字段名称，后面是紧接着是每个字段的值。
     *  @param nRow     查询出多少条记录（即查出多少行）。
     *  @param nColumn  多少个字段（多少列）
     *  @param errmsg   错误信息
     *
     *  @return
     */
    result = sqlite3_get_table ( self.db, sql , &dbResult, &nRow, &nColumn, &errmsg );
    if( SQLITE_OK == result ){
        // 查询成功
        index = nColumn; // 前面说过 dbResult 前面第一行数据是字段名称，从 nColumn 索引开始才是真正的数据
        printf( "查到%d 条记录\n " , nRow );
        for( i = 0; i < nRow ; i++ )
        {
            printf( " 第 %d 条记录\n " , i+1 );
            for( j = 0 ; j < nColumn; j++ )
            {
                printf( " 字段名:%s ß > 字段值:%s\n " , dbResult[j], dbResult [index] );
                ++index; // dbResult 的字段值是连续的，从第0 索引到第 nColumn - 1 索引都是字段名称，从第 nColumn 索引开始，后面都是字段值，它把一个二维的表（传统的行列表示法）用一个扁平的形式来表示
         //       dbResult 的结构  ["字段1","字段2","字段3","第一行第一个字段","第一行第二个字段","第一行第三个字段","第二行第一个字段","第二行第二个字段","第二行第三个字段"]
            }
            printf( " -------\n " );
        }
    }
    // 到这里，不论数据库查询是否成功，都释放 char** 查询结果，使用 sqlite 提供的功能来释放
    sqlite3_free_table ( dbResult );
    // 关闭数据库
sqlite3_close ( self.db );
}



-(IBAction)closedataBase:(id)sender
{
    if( sqlite3_close(self.db)== SQLITE_OK){
        NSLog(@"关闭数据库完成");
    }
}

-(IBAction)openDataBase:(id)sender
{
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"students.sqlite"];
    //将OC字符串转换为c语言的字符串
    const char *cfileName=fileName.UTF8String;
    
    //1.打开数据库文件（如果数据库文件不存在，那么该函数会自动创建数据库文件）
    int result = sqlite3_open(cfileName, &_db);
    if (result == SQLITE_OK) {
        printf("成功打开数据库");
        
    }
    
}

/*
 
 sqlite 操作二进制数据需要用一个辅助的数据类型：sqlite3_stmt *
 可以把 sqlite3_stmt * 所表示的内容看成是 sql 语句，但是实际上它不是我们所熟知的 sql 语句。它是一个已经把 sql 语句解析了的、用 sqlite 自己标记记录的内部数据结构。
 正因为这个结构已经被解析了，所以你可以往这个语句里插入二进制数据,用 sqlite 提供的函数来插入.

 */



// 使用 sqlite3_stmt* 插入
-(IBAction)insertStmt:(id)sender
{
   
//    首先,声明 sqlite3_stmt *
    sqlite3_stmt * stmt;
//    然后把一个sql语句解析到 stmt里去
    char  *sql = "INSERT INTO t_students (name,age) VALUES ('lilei',?);";
    /**
     * sqlite3_prepare(<#sqlite3 *db#>, <#const char *zSql#>, <#int nByte#>, <#sqlite3_stmt **ppStmt#>, <#const char **pzTail#>)
        
        * sqlite3 *db
        * const char *zSql  sql语句
        * int nByte 前面 sql 语句的长度。如果小于 0 ,sqlite 会自动计算它的长度（把 sql 语句当成以 \0 结尾的字符串）
        * sqlite3_stmt **ppStmt  sqlite3_stmt 的指针的指针。解析以后的 sql 语句就放在这个结构里
                        取地址符,等于生成该变量的指针
        * const char **pzTail  这个参数不清楚用法
     */
   int result = sqlite3_prepare(self.db, sql, -1, &stmt, 0);
    if(result == SQLITE_OK && stmt != NULL){
        /**
         *  插入二进制
         sqlite3_bind_blob(<#sqlite3_stmt *#>, <#int#>, <#const void *#>, <#int n#>, <#void (*)(void *)#>)
         
         
         *  @param sqlite3_stmt *  sqlite3_stmt * 类型变量
         
         *  @param int      ? 号的索引。前面 prepare 的 sql 语句里有一个 ? 号，假如有多个 ? 号怎么插入？方法就是改变 bind_blob 函数第 2 个参数。这个参数我写 1 ，表示这里插入的值要替换 stat 的第一个?号(这里的索引从1开始计数，而非从 0 开始）。如果你有多个 ? 号，就写多个 bind_blob语句，并改变它们的第2个参数就替换到不同的 ? 号。如果有 ? 号没有替换， sqlite 为它取值 null 。
         
         *  @param const void *    二进制数据起始指针。
         
         *  @param int n           二进制数据的长度，以字节为单位
         
         *  @param void (*)(void *)   是个析够回调函数，告诉 sqlite 当把数据处理完后调用此函数来析够你的数据。这个参数我还没有使用过，因此理解也不深刻。但是一般都填 NULL ，需要释放的内存自己用代码来释放。
         */
       
        
//     sqlite3_bind_blob(stmt, 1, pdata, ( int )(length_of_data_in_bytes), NULL);

        int age = 10;
        sqlite3_bind_blob(stmt, 1, &age, -1, NULL);
//    bind 完了之后，二进制数据就进入了 stmt 里了。现在可以把它保存到数据库里
        int stmtResult = sqlite3_step (stmt);
        if(stmtResult == SQLITE_OK)  printf("插入数据成功");
    }
    
//    最后，要把 sqlite3_stmt 结构给释放：
    sqlite3_finalize (stmt); // 把刚才分配的内容析构掉
}

// 使用sqlite3_stmt 查询
-(IBAction)selectStmt:(id)sender
{
    const char *selectSql="SELECT id,name,age FROM t_students WHERE age<20;";
    sqlite3_stmt *selStmt;
  int result =  sqlite3_prepare(self.db, selectSql, -1, &selStmt, NULL);
    if (result == SQLITE_OK && selStmt != NULL) {
/*
   int reslut = sqlite3_step(selStmt);
        这一句的返回值是 SQLITE_ROW 时表示成功（不是 SQLITE_OK ）。
        你可以循环执行 sqlite3_step 函数，一次step 查询出一条记录。直到返回值不为 SQLITE_ROW 时表示查询结束。
*/
        while (sqlite3_step(selStmt) == SQLITE_ROW) {
            
            int idColum = sqlite3_column_int(selStmt, 0);
            char *nameColum = sqlite3_column_text(selStmt, 1);
            int ageColum  =sqlite3_column_int(selStmt, 2);
            printf("使用stmt查询到的数据   id-%d  name-%s   age-%d \n",idColum,nameColum,ageColum);
            
        }
        sqlite3_finalize(selStmt); //析构掉 selStmt
  //      result = sqlite3_reset (stat);
   //       prepared语句可以被重置（调用sqlite3_reset函数），然后可以重新绑定参数之后重新执行。sqlite3_prepare_v2函数代价昂贵，所以通常尽可能的重用prepared语句。
  //      这样， stat 结构又成为 sqlite3_prepare 完成时的状态，你可以重新为它 bind 内容。

//        sqlite3_clear_bindings
//        如果想确保绑定到参数的值，不会引起内存泄露。最好在每次重置语句时，清空所有参数绑定。
    }
 
}


/**
 *  事务
 
 sqlite 是支持事务处理的。如果你知道你要同步删除很多数据，不仿把它们做成一个统一的事务。
 通常一 次 sqlite3_exec 就是一次事务，如果你要删除 1 万条数据， sqlite 就做了 1 万次：开始新事务 -> 删除一条数据 -> 提交事务 -> 开始新事务 -> … 的过程。这个操作是很慢的。因为时间都花在了开始事务、提交事务上。
 你可以把这些同类操作做成一个事务，这样如果操作错误，还能够回滚事务。
 事务的操作没有特别的接口函数，它就是一个普通的 sql 语句而已：
 分别如下 ：
 
 int result;
 result = sqlite3_exec ( db, "begin transaction", 0, 0, &zErrorMsg ); // 开始一个事务
 result = sqlite3_exec ( db, "commit transaction", 0, 0, &zErrorMsg ); // 提交事务
 result = sqlite3_exec ( db, "rollback transaction", 0, 0, &zErrorMsg ); // 回滚事务
 
 

 http://www.jb51.net/article/36927.htm
 
 
 
 多个进程可同时打开同一个数据库。多个进程可以同时进行SELECT操作，但在任一时刻，只能有一个进程对数据库进行更改。
 SQLite允许多个进程同时打开一个数据库，同时读一个数据库。当有任何进程想要写时，它必须在更新过程中锁住数据库文件。但那通常只是几毫秒的时间。其它进程只需等待写进程干完活结束。典型地，其它嵌入式的SQL数据库引擎同时只允许一个进程连接到数据库。
 但是，Client/Server数据库引擎（如PostgreSQL, MySQL,或Oracle）通常支持更高级别的并发，并且允许多个进程同时写同一个数据库。这种机制在Client/Server结构的数据库上是可能的，因为总是有一个单一的服务器进程很好地控制、协调对数据库的访问。如果你的应用程序需要很多的并发，那么你应该考虑使用一个Client/Server结构的数据库。但经验表明，很多应用程序需要的并发，往往比其设计者所想象的少得多。
 
 当SQLite试图访问一个被其它进程锁住的文件时，缺省的行为是返回SQLITE_BUSY。可以在C代码中使用sqlite3_busy_handler()或sqlite3_busy_timeout() API函数调整这一行为。
 
 
 9、SQLite线程安全吗？
 线程是魔鬼（Threads are evil）。避免使用它们。
 SQLite是线程安全的。由于很多用户会忽略我们在上一段中给出的建议，我们做出了这种让步。但是，为了达到线程安全，SQLite在编译时必须将SQLITE_THREADSAFE预处理宏置为1。在Windows和Linux上，已编译的好的二进制发行版中都是这样设置的。如果不确定你所使用的库是否是线程安全的，可以调用sqlite3_threadsafe()接口找出。
 
 
 
 10、在SQLite数据库中如何列出所有的表和索引？
 如果你运行sqlite3命令行来访问你的数据库，可以键入“.tables”来获得所有表的列表。或者，你可以输入“.schema”来看整个数据库模式，包括所有的表的索引。输入这些命令，后面跟一个LIKE模式匹配可以限制显示的表。
 
 

 12、在SQLite中，VARCHAR字段最长是多少？
 SQLite不强制VARCHAR的长度。你可以在SQLITE中声明一个VARCHAR(10)，SQLite还是可以很高兴地允许你放入500个字符。并且这500个字符是原封不动的，它永远不会被截断。
 
 
 SQLite有有限地ALTER TABLE支持。你可以使用它来在表的末尾增加一列，可更改表的名称。如果需要对表结构做更复杂的改变，则必须重新建表。重建时可以先将已存在的数据放到一个临时表中，删除原表，创建新表，然后将数据从临时表中复制回来。

 
 */


@end