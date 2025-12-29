/*
  Stress testing
  โดยเปลี่ยน vus 1 → 3 → 4 → 5 → 8 → 10 → 0 
  ภายในเวลา 30s → 1m30s → 35s → 1m → 1m15s → 1m30s → 10s ตามลำดับ
  และตั้ง threshold ว่า
  - http_req_duration: ['p(95)<1000'] 
  - http_req_failed: ['rate<0.01']

  ผลการทดสอบ
  http_req_duration : avg=368.1ms, p(90)=883.92ms, p(95)=1.1s
  http_req_failed   : 0.00%  
  vus               : 1
  vus_max           : 10

  จุดที่ระบบเริ่มมีปัญหาด้านประสิทธิภาพอยู่ที่ประมาณ 4 VUs เพราะเวลาเกิน 1 วินาที (http_req_duration p(95)) 
  แต่ยังไม่มี error (http_req_failed = 0%)
*/
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
    stages: [
        { duration: '30s', target: 1 },
        { duration: '1m30s', target: 3 },
        { duration: '35s', target: 4 },
        { duration: '1m', target: 5 },
        { duration: '1m15s', target: 8 },
        { duration: '1m30s', target: 10 },
        { duration: '10s', target: 0 },],

    thresholds: {
        http_req_failed: ['rate<0.01'],
        http_req_duration: ['p(95)<1000'],
    },
}; export default function () {
    const res = http.get('http://10.34.112.158:8000/dk/store'); check(res, { 'status was 200': (r) => r.status == 200 });
    sleep(1);
}