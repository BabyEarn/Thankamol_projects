/* Average-load test 

  ผลการทดสอบ
  duration time เป็น 30 วินาที และ virtual user เป็นดังนี้
  3 vus → avg=232.02ms, p(90)=457.54ms, p(95)=728.83ms 
  4 vus → avg=268.07ms, p(90)=760.25ms, p(95)=1.05s
  5 vus → avg=249.57ms, p(90)=376.03ms, p(95)=1.24s
  8 vus → avg=561.73ms, p(90)=1.56s, p(95)=1.96s
  10 vus → avg=803.93ms, p(90)=2.16s, p(95)=2.33s

  ระบบจะรองรับผู้ใช้พร้อมกันได้สูงสุดประมาณ 3 users ก่อนที่ค่า response time จะเกิน 1 วินาที
  แต่ยังไม่มีปัญหา error หรือการส่งคำขอล้มเหลว (http_req_failed: 0%)
*/
import http from 'k6/http';
import { sleep } from 'k6';

export default function () {
  http.get('http://10.34.112.158:8000/dk/store');
  sleep(1);
}
