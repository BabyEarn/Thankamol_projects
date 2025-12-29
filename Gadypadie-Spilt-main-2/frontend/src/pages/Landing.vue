<template>
  <div class="p24">
    <section class="card p32" style="background:var(--panel-gradient); color:#fff; border:0">
      <h1 class="h1" style="color:#fff">หารไม่เท่ากัน ได้ง่ายๆ</h1>
      <p class="h2" style="color:#fff; opacity:.9">GADYPADIE SPLIT — ระบบช่วยหารค่าใช้จ่ายกลุ่ม</p>
      <div class="mt24" style="display:flex; gap:12px">
        <button class="btn" @click="$router.push('/home')">เริ่มใช้งานฟรี</button>
        <button class="btn-outline" @click="$router.push('/login')">เข้าสู่ระบบ</button>
      </div>
    </section>

    <section class="card p32 mt24">
      <h2 class="h2">ฟีเจอร์เด่น</h2>
      <div style="display:grid; grid-template-columns:repeat(auto-fit,minmax(220px,1fr)); gap:16px; margin-top:16px">
        <div class="card p16">🧮 หารไม่เท่ากัน</div>
        <div class="card p16">🤝 แชร์ลิงก์ให้เพื่อน</div>
        <div class="card p16">⚖️ โอนน้อยครั้ง</div>
        <div class="card p16">📱 Responsive</div>
      </div>
    </section>

    <section class="card p32 mt24" style="text-align:center">
      <h3 class="h2">พร้อมเริ่มเลย?</h3>
      <div class="mt16"><button class="btn" @click="$router.push('/home')">สร้างบิล</button></div>
    </section>
  </div>
</template>
