<?php 
   $today = "현재는 ".date("Y-m-j")." 입니다.";
   echo $today, "<br>";
   
   $ary = array(100, 50, 200, 7);
   echo "최대:", max($ary) ," 최소:", min(-123, 50, 999), "<br>";
   
   echo pi(), " ", round(M_PI), " ",ceil(M_PI), "<br>";
   
   $str = "   IT CookBook MySQL   "; // 앞뒤에 공백 3개씩.
   $str = trim($str);
   echo "#", $str, "#", "<br>";
   
   echo "문자열 길이:", strlen($str), "<br>";
   
   echo str_repeat("-", 30), "<br>";
   
   echo str_replace( "MySQL", "마이에스큐엘", "IT CookBook MySQL"), "<br>";
   
   $ary = str_split("IT CookBook MySQL", 3);
   print_r($ary); echo "<br>"; // 배열을 출력한다.
   echo "<br>";
   
   $ary = explode(" ", "IT CookBook MySQL");
   print_r($ary); echo "<br>";// 배열을 출력한다.
   
   echo implode($ary, " "), "<br>";
   
   $myHTML = "<A href='www.hanbit.co.kr'> 한빛아카데미 </A> <br>";
   echo $myHTML;
   echo htmlspecialchars($myHTML);  
 ?>