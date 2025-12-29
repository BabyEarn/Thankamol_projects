## Performance testing
Performance testing ด้วย K6 ซึ่งการทดสอบครอบคลุม Performance 4 รูปแบบ ได้แก่
1. Average-load test
2. Stress testing
3. Soak testing
4. Spike testing

เป็นการ testing เพื่อดูว่าระบบจะตอบ request เร็วแค่ไหน (http_req_duration), มี request ที่ล้มเหลวไหม (http_req_failed) และระบบรองรับผู้ใช้พร้อมกันสูงสุดเท่าไหร่ (vus_max)

### Average-load test
**Purpose:**
เพื่อทดสอบระบบว่าจะสามารถรองรับผู้ใช้ได้สูงสุดกี่คนก่อนที่ค่า response time จะเกิน 1 วินาที

#### average-load_script.js
```js
import http from 'k6/http';
import { sleep } from 'k6';

export default function () {
  http.get('http://10.34.112.158:8000/dk/store');
  sleep(1);
}
```

**Run the test script**
โดยตั้งค่า VUs ระหว่างรัน script duration time เป็น 30 วินาที 
```bash
# Average-load test with 3 VUs
k6 run --vus 3 --duration 30s script.js

# Average-load test with 4 VUs
k6 run --vus 4 --duration 30s script.js

# Average-load test with 5 VUs
k6 run --vus 5 --duration 30s script.js

# Average-load test with 8 VUs
k6 run --vus 8 --duration 30s script.js

# Average-load test with 10 VUs
k6 run --vus 10 --duration 30s script.js
```

**Result** 
* TOTAL RESULTS
  * http_req_duration : avg = 232.02ms, min = 6.83ms, med = 246.19ms, max = 1.67s, p(90) = 457.54ms, p(95) = 728.83ms
  * http_req_failed   : 0.00%  (0 out of 126)
  * http_reqs         : 126   (4.041881/s)

* EXECUTION
  * iteration_duration : avg = 1.46s, min = 1.24s, med = 1.35s, max = 2.75s, p(90) = 1.68s, p(95) = 2.07s
  * iterations         : 63   (2.020941/s)
  * vus                : 1      (min = 1, max = 3)
  * vus_max            : 3      (min = 3, max = 3)

* NETWORK
  * data_received      : 7.8 MB  (249 kB/s)
  * data_sent          : 17 kB   (550 B/s)

running (30s), 0/3 VUs, 63 complete and 0 interrupted iterations

**ระบบสามารถรองรับผู้ใช้ได้สูงสุดกี่คนก่อนที่ค่า response time จะเกิน 1 วินาที?**
* ระบบจะรองรับผู้ใช้พร้อมกันได้สูงสุดประมาณ 3 users ก่อนที่ค่า response time จะเกิน 1 วินาที
* แต่ยังไม่มีปัญหา error หรือการส่งคำขอล้มเหลว (http_req_failed: 0%)

### Stress testing
**Purpose:**
เพื่อทดสอบระบบว่าเริ่มช้าลงและมีปัญหาด้านประสิทธิภาพที่จุดโหลดประมาณเท่าไหร่

#### stress_script.js
โดยเปลี่ยน vus 1 → 3 → 4 → 5 → 8 → 10 → 0 ภายในเวลา 30s → 1m30s → 35s → 1m → 1m15s → 1m30s → 10s ตามลำดับ
และตั้ง threshold ว่า
* http_req_duration: ['p(95)<1000'] 
* http_req_failed: ['rate<0.01']
```js
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
```

**Run the test script**
```bash
k6 run script.js
```

**Result**
* THRESHOLDS
  * http_req_duration : ✗ 'p(95)<1000'  (p(95) = 1.1s)
  * http_req_failed   : ✓ 'rate<0.01'   (rate = 0.00%)

* TOTAL RESULTS
  * checks_total      : 1030   (2.63794/s)
  * checks_succeeded  : 100.00%  (1030 out of 1030)
  * checks_failed     : 0.00%    (0 out of 1030)

  status was 200    : ✓

* HTTP
  * http_req_duration : avg = 368.1ms, min = 5.93ms, med = 231.9ms, max = 6.04s, p(90) = 883.92ms, p(95) = 1.1s
  * http_req_failed   : 0.00%  (0 out of 2060)
  * http_reqs         : 2060   (5.275879/s)

* EXECUTION
  * iteration_duration : avg = 1.73s, min = 1.22s, med = 1.44s, max = 7.14s, p(90) = 2.17s, p(95) = 3.34s
  * iterations         : 1030   (2.63794/s)
  * vus                : 1      (min = 1, max = 10)
  * vus_max            : 10     (min = 10, max = 10)

* NETWORK
  * data_received      : 127 MB  (324 kB/s)
  * data_sent          : 280 kB  (718 B/s)
running (6m30.5s), 0/10 VUs, 1030 complete and 0 interrupted iterations

**ในการทำ Stress Test: จุดที่ระบบเริ่มแสดงปัญหาคือที่จำนวน virtual users (VUs) เท่าใด?**
* จุดที่ระบบเริ่มมีปัญหาด้านประสิทธิภาพอยู่ที่ประมาณ 4 VUs เพราะเวลาเกิน 1 วินาที (http_req_duration p(95))  
* แต่ยังไม่มี error (http_req_failed = 0%)

### Soak testing
**Purpose:**
เพื่อทดสอบระบบเมื่อมีการใช้งานต่อเนื่องนานๆ และตรวจว่ามีปัญหา memory leak หรือ error สะสมหรือไม่ 


#### soak_script.js
vus เป็น 3 และใช้เวลานาน 30 นาที และตั้ง threshold ว่า
* http_req_duration: ['p(95)<1000'] 
* http_req_failed: ['rate<0.01']
```js
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
```

**Run the test script**
```bash
k6 run script.js
```

**Result**
* THRESHOLDS
  * http_req_duration : ✓ 'p(95)<1000'  (p(95) = 475.5ms)
  * http_req_failed   : ✓ 'rate<0.01'   (rate = 0.07%)

* TOTAL RESULTS
  * checks_total      : 2820   (1.483831/s)
  * checks_succeeded  : 99.96%  (2819 out of 2820)
  * checks_failed     : 0.03%   (1 out of 2820)

  status was 200      : ✗  (99% — ✓ 2819 / ✗ 1)

* HTTP
  * http_req_duration : avg = 510.13ms, min = 5.14ms, med = 218.88ms, max = 7m50s, p(90) = 350.96ms, p(95) = 475.5ms
  * http_req_failed   : 0.07%  (4 out of 5644)
  * http_reqs         : 5644   (2.969767/s)

* EXECUTION
  * iteration_duration : avg = 1.52s, min = 1.2s, med = 1.3s, max = 20.28s, p(90) = 1.49s, p(95) = 2.3s
  * iterations         : 2820   (1.483831/s)
  * vus                : 2      (min = 2, max = 3)
  * vus_max            : 3      (min = 3, max = 3)

* NETWORK
  * data_received      : 347 MB  (182 kB/s)
  * data_sent          : 768 kB  (404 B/s)


**ในการทำ Soak Test: มี memory leak หรือปัญหาคงค้าง (residual errors) เกิดขึ้นหลังจากโหลดต่อเนื่องนาน ๆ หรือไม่?**
* ไม่พบปัญหา memory leak หรือ residual errors เกิดขึ้นหลังจากโหลดต่อเนื่องนานๆ เพราะตลอดการ run 30 นาที ค่า response time (http_req_duration p(95)) ยังต่ำกว่า 1 วินาที
* และ error (http_req_failed) ยังอยู่ในระดับต่ำอยู่ (0.07%)

### Spike testing
**Purpose:**
เพื่อดูว่าระบบรับมือกับ VUs ที่ขึ้นสูงทันทีได้แค่ไหน และฟื้นตัวกลับมาจะมี response time ตามเกณฑ์ (p95 < 1s) หรือไม่

#### spike_script.js
โดยเปลี่ยน vus เป็น 3 → 50 (มีการโหลดอย่างรวดเร็ว) → 10 → 0 ภายในเวลา 30s → 30s → 1m → 10s ตามลำดับ
และตั้ง threshold ว่า
* http_req_duration: ['p(95)<1000'] 
* http_req_failed: ['rate<0.01']
```js
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
```

**Run the test script**
```bash
k6 run script.js
```

**Result**
* TOTAL RESULTS
  * checks_total      : 322   (2.460574/s)
  * checks_succeeded  : 100.00%  (322 out of 322)
  * checks_failed     : 0.00%    (0 out of 322)

  status was 200      : ✓

* HTTP
  * http_req_duration : avg = 4.01s, min = 6.62ms, med = 1.27s, max = 16.06s, p(90) = 11.11s, p(95) = 14.6s
  * http_req_failed   : 0.00%  (0 out of 644)
  * http_reqs         : 644   (4.921149/s)

* EXECUTION
  * iteration_duration : avg = 9.03s, min = 1.25s, med = 9.34s, max = 18.56s, p(90) = 15.83s, p(95) = 16.86s
  * iterations         : 322   (2.460574/s)
  * vus                : 1      (min = 1, max = 50)
  * vus_max            : 50     (min = 50, max = 50)

* NETWORK
  * data_received      : 40 MB   (302 kB/s)
  * data_sent          : 88 kB   (669 B/s)


**ใน Spike Test: ระบบสามารถฟื้นตัวกลับมาให้บริการตามปกติหลังจาก spike ได้เร็วแค่ไหน? (Recovery Time)**
* ระบบไม่สามารถฟื้นตัวได้เร็วจาก spike คือ จาก 3 vuu → 50 vus
* เพราะ p(95) มีค่ามากถึง 14.6 วินาที และระบบไม่สามารถกลับมาทำงานได้ตามปกติในเวลา 1 วินาที
* แต่ยังไม่มี error (http_req_failed = 0%)

### Question
1. ระบบสามารถรองรับผู้ใช้ได้สูงสุดกี่คนก่อนที่ค่า response time จะเกิน 1 วินาที?
* ระบบจะรองรับผู้ใช้พร้อมกันได้สูงสุดประมาณ 3 users ก่อนที่ค่า response time จะเกิน 1 วินาที
* แต่ยังไม่มีปัญหา error หรือการส่งคำขอล้มเหลว (http_req_failed: 0%)
2. ในการทำ Stress Test: จุดที่ระบบเริ่มแสดงปัญหาคือที่จำนวน virtual users (VUs) เท่าใด?
* จุดที่ระบบเริ่มมีปัญหาด้านประสิทธิภาพอยู่ที่ประมาณ 4 VUs เพราะเวลาเกิน 1 วินาที (http_req_duration p(95))  
* แต่ยังไม่มี error (http_req_failed = 0%)
3. ในการทำ Soak Test: มี memory leak หรือปัญหาคงค้าง (residual errors) เกิดขึ้นหลังจากโหลดต่อเนื่องนาน ๆ หรือไม่?
* ไม่พบปัญหา memory leak หรือ residual errors เกิดขึ้นหลังจากโหลดต่อเนื่องนานๆ เพราะตลอดการ run 30 นาที ค่า response time (http_req_duration p(95)) ยังต่ำกว่า 1 วินาที
* และ error (http_req_failed) ยังอยู่ในระดับต่ำอยู่ (0.07%)
4. ใน Spike Test: ระบบสามารถฟื้นตัวกลับมาให้บริการตามปกติหลังจาก spike ได้เร็วแค่ไหน? (Recovery Time)
* ระบบไม่สามารถฟื้นตัวได้เร็วจาก spike คือ จาก 3 vuu → 50 vus
* เพราะ p(95) มีค่ามากถึง 14.6 วินาที และระบบไม่สามารถกลับมาทำงานได้ตามปกติในเวลา 1 วินาที
* แต่ยังไม่มี error (http_req_failed = 0%)
5. ค่า http_req_failed, http_req_duration, และ vus_max บอกอะไรเกี่ยวกับประสิทธิภาพของระบบในแต่ละกรณี
  * http_req_faile เป็นตัวบอกว่าคำขอที่ล้มเหลวมีมากน้อยแค่ไหน
  * http_req_duration เป็นค่าที่บอกว่าระบบจะตอบสนองได้เร็วแค่ไหน
  * vus_max เป็นค่าที่บอกว่าระบบรองรับผู้ใช้พร้อมกันสูงสุดเท่าไหร่ 
