package com.fp.delight.api;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.XML;
import com.fp.delight.performent.model.PerformentListVO;


//메인1 맨 처음 로딩했을 때, 연극 API를 먼저 고정으로 뿌려주는 소스 -예진-
public class ApiTest_Index {
   public int INDENT_FACTOR = 4;
   
   public List<PerformentListVO> receiveAPI() throws MalformedURLException, IOException{
	  //메인1 처음 로딩했을 때, 뿌려주는 API 검색 조건입니다. -예진-
	   
	  //14일 전 날짜 변수선언
	  String minus = null;
	  
	  //7일 후 날짜 변수 선언
	  String plus = null;
	  
	  //현재 날짜 생성
	  Date date = new Date();
	  
	  //포멧변경(년월일)
	  SimpleDateFormat timeformat = new SimpleDateFormat("yyyyMMdd");
	  
	  //캘린더 생성
	  Calendar cal = Calendar.getInstance();
	  
	  //캘린더에 오늘날짜 저장
	  cal.setTime(date);
	  
	  //현재날짜로부터 14일 전 날짜 구하고 저장
	  cal.add(Calendar.DATE, -14);	  
	  minus = timeformat.format(cal.getTime());
	  
	  //현재날짜로부터 7일 후 날짜 구하고 저장
	  cal.add(Calendar.DATE, 7);
	  plus = timeformat.format(cal.getTime());
	  
	  //1~3페이지까지 랜덤으로 값을 선택해서 메인1을 로딩 할 때마다, 다른 값을 뿌려준다
	  //난수 생성
	  int randomValue;
	  randomValue = (int)(Math.random()*3 + 1);
	  
	  //API 공공데이터 받아오는 타입 설정. AAAA=연극, AAAB=뮤지컬
	  //맨처음 메인페이지에서는 연극으로 셋팅 해놓는다
	  String th="AAAA";
	  
	  //API 공공데이터 URL 설정
	  String apiurl="http://www.kopis.or.kr/openApi/restful/pblprfr?"
	            + "service=4c8aebff91d74e2396fccc287989884a"
	            + "&stdate="+minus
	            + "&eddate="+plus
	            + "&cpage="+randomValue
	            + "&rows=20"
	            + "&shcate="+th;
	  
	  //URL 연결
      HttpURLConnection urlcon=(HttpURLConnection) new URL(apiurl).openConnection();
      
      urlcon.connect();
      BufferedInputStream bis = new BufferedInputStream(urlcon.getInputStream());
        BufferedReader reader = new BufferedReader(new InputStreamReader(bis));
        StringBuffer st = new StringBuffer();
        String line;
        while ((line = reader.readLine()) != null) {
            st.append(line);
        }
 
        JSONObject xmlJSONObj = XML.toJSONObject(st.toString());
        String jsonPrettyPrintString = xmlJSONObj.toString(INDENT_FACTOR);
       
        JSONArray jsonarr=xmlJSONObj.getJSONObject("dbs").getJSONArray("db");
        ObjectMapper mapper = new ObjectMapper();
       
        List<PerformentListVO> list=null;
        list=mapper.readValue(jsonarr.toString(), new TypeReference<List<PerformentListVO>>() {});

        //디버깅
        for(int i=0;i<list.size();i++) {
           PerformentListVO vo=list.get(i);
           System.out.println("공연 id="+vo.getMt20id());
        }
        
        //Controller
        return list;
   }
}//class