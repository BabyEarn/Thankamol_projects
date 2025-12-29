/*
  Spike Test
  โดยเปลี่ยน vus เป็น 3 → 50 (มีการโหลดอย่างรวดเร็ว) → 10 → 0 
  ภายในเวลา 30s → 30s → 1m → 10s ตามลำดับ
  และตั้ง threshold ว่า
  - http_req_duration: ['p(95)<1000'] 
  - http_req_failed: ['rate<0.01']

  ผลการทดสอบ
  http_req_duration : avg=4.01s, p(90)=11.11s, p(95)=14.6s
  http_req_failed   : 0.00%
  vus_max           : 50

  ระบบไม่สามารถฟื้นตัวได้เร็วจาก spike คือ จาก 3 vuu → 50 vus 
  เพราะ p(95) มีค่ามากถึง 14.6 วินาที 
  และระบบไม่สามารถกลับมาทำงานได้ตามปกติในเวลา 1 วินาที
  แต่ยังไม่มี error (http_req_failed = 0%)
*/

import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '30s', target: 3 },
    { duration: '30s', target: 50 },
    { duration: '1m', target: 10 },
    { duration: '10s', target: 0 },
  ],

  thresholds: {
    http_req_duration: ['p(95)<1000'],
    http_req_failed: ['rate<0.01'],
  },
};

export default function () {
  const res = http.get('http://10.34.112.158:8000/dk/store');
  check(res, { 'status was 200': (r) => r.status == 200 });
  sleep(1);
}