<?php
   $con=mysqli_connect("localhost", "cookUser", "4321") or die("MySQL 접속 실패");
   phpinfo();
   mysqli_close($con);
?>
