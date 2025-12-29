/*
  Soak testing
  vus เป็น 3 และใช้เวลานาน 30 นาที
  และตั้ง threshold ว่า
  - http_req_duration: ['p(95)<1000'] 
  - http_req_failed: ['rate<0.01']

  ผลการทดสอบ
  http_req_duration : avg=510.13ms, p(90)=350.96ms, p(95)=475.5ms
  http_req_failed   : 0.07%  (4 จาก 5644)
  vus_max           : 3

  ไม่พบปัญหา memory leak หรือ residual errors เกิดขึ้นหลังจากโหลดต่อเนื่องนาน ๆ 
  เพราะตลอดการ run 30 นาที ค่า response time (http_req_duration p(95)) ยังต่ำกว่า 1 วินาที
  และ error (http_req_failed) ยังอยู่ในระดับต่ำอยู่ (0.07%) 
*/

import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 3,
  duration: '30m',

  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<1000'],
  },
};

export default function () {
  const res = http.get('http://10.34.112.158:8000/dk/store');
  check(res, { 'status was 200': (r) => r.status === 200 });
  sleep(1);
}
