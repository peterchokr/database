<?php
   $con=mysqli_connect("localhost", "cookUser", "1234", "cookDB") or die("MySQL 접속 실패 !!");

   $sql ="
		SELECT * FROM userTBL
   ";
 
   $ret = mysqli_query($con, $sql);
 
   if($ret) {
	   echo mysqli_num_rows($ret), "건이 검색됨.<br><br>";
   }
   else {
	   echo "userTBL 데이터 검색 실패!!!"."<br>";
	   echo "실패 원인 :".mysqli_error($con);
	   exit();
   }
   
   while($row = mysqli_fetch_array($ret)) {
	   echo $row['userID'], " ", $row['userName'], " ", $row['height'], " ", "<br>";
   }   
 
   mysqli_close($con);
?>
