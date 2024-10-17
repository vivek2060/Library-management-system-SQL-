drop database if exists library;
create database library;
use library;
drop table if exists tbl_publisher;
create table tbl_publisher(publisher_publisherName varchar(100) primary key ,
publisher_publisherAddress varchar(100) not null,publisher_publisherPhone varchar(100) not null);
desc tbl_publisher;
drop table if exists tbl_book;
create table tbl_book(book_bookId int not null auto_increment,
book_title varchar(100)not null,
book_publisherName varchar(100) not null,
primary key(book_bookId),
foreign key(book_publisherName)
references tbl_publisher(publisher_publisherName)on delete cascade);
desc tbl_book;
drop table if exists tbl_book_authors;
create table tbl_book_authors(book_authors_authorId int not null auto_increment,
book_authors_bookId int not null,
book_authors_authorname varchar(100) not null,
primary key(book_authors_authorId),
foreign key(book_authors_bookId)
references tbl_book(book_bookId)on delete cascade);
desc tbl_book_authors;
drop table if exists tbl_librarybranch;
create table tbl_librarybranch(library_branch_branchId int primary key auto_increment,
library_branch_branchName varchar(100) not null,
library_branch_branchAddress varchar(100) not null); 
desc tbl_librarybranch;
drop table if exists tbl_book_copies;
create table tbl_book_copies(book_copies_copiesId int not null auto_increment,
book_copies_bookId int not null,
book_copies_branchId int not null,
book_copies_no_of_copies int not null,
primary key(book_copies_copiesId),
foreign key(book_copies_bookId)
references tbl_book(book_bookId),
foreign key(book_copies_branchId)
references tbl_librarybranch(library_branch_branchId)on delete cascade);
desc tbl_book_copies;
drop table if exists tbl_borrower;
create table tbl_borrower(borrower_cardno int primary key auto_increment,
borrower_borrowerName varchar(100)not null,
borrower_borrowerAddress varchar(100)not null,
borrower_borrowerphone varchar(100) not null);
desc tbl_borrower;
drop table if exists tbl_book_loans;
create table tbl_book_loans(book_loans_loansId int auto_increment,
book_loans_bookId int not null,
book_loans_branchId int not null,
book_loans_cardNo int not null,
book_loans_dateout date not null,
book_loans_duedate date not null,
primary key(book_loans_loansId),
foreign key(book_loans_bookId)
references tbl_book(book_bookId),
foreign key(book_loans_branchId)
references tbl_librarybranch(library_branch_branchId),
foreign key(book_loans_cardNo)
references tbl_borrower(borrower_cardNo)on delete cascade);
desc tbl_book_loans;
select* from tbl_publisher;
select * from tbl_book;
select* from tbl_book_authors;
select* from tbl_librarybranch;
select* from tbl_book_copies;
select* from tbl_borrower;
select* from tbl_book_loans;
        -- 1.How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?

select l.library_branch_branchName, c.book_copies_no_of_copies ,b.book_title from tbl_book_copies c inner join 
 tbl_librarybranch l on l.library_branch_branchId=c.book_copies_branchId inner join tbl_book b on 
 b.book_bookId=c.book_copies_bookid where l.library_branch_branchName="sharpstown" and b.book_title="The Lost Tribe";
 
          -- 2.How many copies of the book titled "The Lost Tribe" are owned by each library branch?

 select l.library_branch_branchName, c.book_copies_no_of_copies ,b.book_title from tbl_book_copies c inner join 
 tbl_librarybranch l on l.library_branch_branchId=c.book_copies_branchId inner join tbl_book b on 
 b.book_bookId=c.book_copies_bookid where b.book_title="The Lost Tribe";
 
 
          -- 3.Retrieve the names of all borrowers who do not have any books checked out.

 select b.borrower_borrowerName from tbl_borrower b where b.borrower_cardno  not in(select l.book_loans_cardNo from tbl_book_loans l);
 
 
   /* 4.For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, 
              retrieve the book title, the borrower's name, and the borrower's address.*/ 
  
 select d.book_title,b.borrower_borrowerName,b.borrower_borrowerAddress ,l.book_loans_duedate,f.library_branch_branchName from tbl_borrower b 
 inner join tbl_book_loans l on l.book_loans_cardNo=b.borrower_cardno inner join tbl_book d on 
 d.book_bookId=l.book_loans_bookId inner join tbl_librarybranch f on
 l.book_loans_branchId=f.library_branch_branchId  where f.library_branch_branchName="sharpstown" and l.book_loans_duedate="2018-02-03" ;
 
    -- 5.For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
 
 select l.library_branch_branchName,sum(book_loans_bookID) from tbl_librarybranch l inner join tbl_book_loans b
 on l.library_branch_branchId=b.book_loans_branchId group by l.library_branch_branchname;
 
 
 
      -- 6.Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
select b.borrower_borrowerName,b.borrower_borrowerAddress,count(l.book_loans_bookId) as count from tbl_borrower b inner join tbl_book_loans l
on b.borrower_cardno=l.book_loans_cardNo inner join tbl_book d on
 d.book_bookId=l.book_loans_bookId group by b.borrower_borrowerName,b.borrower_borrowerAddress having count>5;



-- 7.For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
select b.book_title,c.book_copies_no_of_copies ,a.book_authors_authorname,l.library_branch_branchName from tbl_book_authors a inner join tbl_book b
on a.book_authors_bookId=b.book_bookId inner join tbl_book_copies c on b.book_bookId=c.book_copies_bookId
inner join tbl_librarybranch l on c.book_copies_branchId=l.library_branch_branchId where 
l.library_branch_branchName="Central" and a.book_authors_authorname="Stephen King";