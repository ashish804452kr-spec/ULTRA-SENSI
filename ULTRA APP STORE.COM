<!DOCTYPE html>
<html lang="hi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ultra App Store - Official</title>
    <style>
        :root { --primary: #ff6600; --dark: #0a0a0a; --vip: #ffea00; }
        body { margin: 0; font-family: 'Poppins', sans-serif; background: var(--dark); color: #fff; }
        
        /* Header */
        .header { background: #111; padding: 15px; display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid var(--primary); position: sticky; top: 0; z-index: 1000; }
        .logo-area { display: flex; align-items: center; gap: 10px; }
        .logo-img { width: 40px; height: 40px; border-radius: 8px; border: 1px solid var(--primary); }
        .search-bar { flex: 1; margin: 0 15px; background: #222; border: none; padding: 10px; border-radius: 20px; color: #fff; }
        
        /* VIP & Gemini Buttons */
        .nav-icons { display: flex; align-items: center; gap: 15px; }
        .vip-badge { background: var(--vip); color: #000; padding: 3px 8px; border-radius: 5px; font-weight: bold; font-size: 12px; box-shadow: 0 0 10px var(--vip); }
        .gemini-btn { cursor: pointer; font-size: 20px; filter: drop-shadow(0 0 5px #00f2ff); }

        /* App Grid */
        .section-title { padding: 20px 15px 5px; font-size: 18px; color: var(--primary); }
        .app-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(110px, 1fr)); gap: 15px; padding: 15px; }
        .app-card { background: #1a1a1a; padding: 12px; border-radius: 15px; text-align: center; cursor: pointer; transition: 0.3s; }
        .app-card:hover { transform: translateY(-5px); background: #252525; }
        .app-card img { width: 70px; height: 70px; border-radius: 18px; margin-bottom: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.5); }
        .app-name { font-size: 13px; font-weight: bold; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }

        /* Download Page Overlay */
        .overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: var(--dark); z-index: 2000; overflow-y: auto; padding-top: 20px; }
        .dl-header { text-align: center; padding: 20px; }
        .dl-btn { background: #01875f; color: #fff; padding: 12px 60px; border-radius: 30px; text-decoration: none; font-weight: bold; display: inline-block; margin-top: 20px; }
        
        /* Payment Modal */
        .modal { display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); background: #222; padding: 25px; border-radius: 20px; border: 2px solid var(--vip); z-index: 3000; width: 85%; max-width: 400px; text-align: center; }
    </style>
</head>
<body>

    <div class="header">
        <div class="logo-area">
            <img src="IMG_20260501_103729.jpg" class="logo-img"> <div style="font-weight: bold; font-size: 14px;">Ultra App</div>
        </div>
        <input type="text" class="search-bar" placeholder="Search apps & games...">
        <div class="nav-icons">
            <span class="gemini-btn" onclick="askJarvis()">🤖</span>
            <div class="vip-badge" onclick="showVip()">VIP</div>
            <div style="font-size: 22px;">☰</div>
        </div>
    </div>

    <div class="section-title">FEATURED BY SUSHIL</div>
    <div class="app-grid">
        <div class="app-card" onclick="openPage('Ultra Sensi Pro', 'IMG_20260501_103729.jpg', '4.9', '12MB')">
            <img src="IMG_20260501_103729.jpg">
            <div class="app-name">Ultra Sensi</div>
        </div>
    </div>

    <div class="section-title">POPULAR APPS</div>
    <div class="app-grid" id="appsContainer">
        </div>

    <div id="dlPage" class="overlay">
        <div style="padding: 20px;" onclick="closePage()">⬅ Back</div>
        <div class="dl-header">
            <img id="dlIcon" src="" style="width: 120px; border-radius: 25px;">
            <h2 id="dlName">App Name</h2>
            <p style="color: #01875f; font-weight: bold;">Verified by Ultra App Store</p>
            <div style="display: flex; justify-content: space-around; margin: 20px 0; border-top: 1px solid #333; padding-top: 10px;">
                <div><b id="dlRating">4.5</b>★</div>
                <div><b id="dlSize">25MB</b></div>
                <div><b>1M+</b> Downloads</div>
            </div>
            <a href="#" class="dl-btn" onclick="alert('Downloading Started...')">Install</a>
        </div>
    </div>

    <div id="vipModal" class="modal">
        <h2 style="color: var(--vip);">Become a VIP Member</h2>
        <p>VIP बनने के लिए ₹500 भेजें और प्रीमियम ऐप्स पाएँ।</p>
        <div style="background: #111; padding: 15px; border-radius: 10px; margin-bottom: 15px; text-align: left;">
            <b>Bank:</b> Bank of India<br>
            <b>Mobile:</b> 9934627814<br>
            <b>Name:</b> Ashish Kumar
        </div>
        <button onclick="this.parentElement.style.display='none'" style="background: var(--primary); border:none; padding: 10px 20px; border-radius: 5px; color: #fff;">Close</button>
    </div>

    <script>
        const apps = [
            { name: "CapCut", img: "https://cdn.iconscout.com/icon/free/png-256/capcut-4573356-3801235.png", rating: "4.8", size: "90MB" },
            { name: "Free Fire", img: "https://static.wikia.nocookie.net/free-fire/images/1/1b/App_icon.png", rating: "4.5", size: "600MB" },
            { name: "PUBG", img: "https://w7.pngwing.com/pngs/391/337/png-transparent-pubg-mobile-logo-thumbnail.png", rating: "4.6", size: "750MB" },
            { name: "Cricket 24", img: "https://cdn-icons-png.flaticon.com/512/1151/1151125.png", rating: "4.2", size: "55MB" },
            { name: "Snake", img: "https://cdn-icons-png.flaticon.com/512/528/528107.png", rating: "4.7", size: "5MB" }
        ];

        // Load Apps
        const container = document.getElementById('appsContainer');
        apps.forEach(app => {
            container.innerHTML += `
                <div class="app-card" onclick="openPage('${app.name}', '${app.img}', '${app.rating}', '${app.size}')">
                    <img src="${app.img}">
                    <div class="app-name">${app.name}</div>
                </div>`;
        });

        function openPage(name, img, rating, size) {
            document.getElementById('dlName').innerText = name;
            document.getElementById('dlIcon').src = img;
            document.getElementById('dlRating').innerText = rating;
            document.getElementById('dlSize').innerText = size;
            document.getElementById('dlPage').style.display = 'block';
        }

        function closePage() { document.getElementById('dlPage').style.display = 'none'; }
        function showVip() { document.getElementById('vipModal').style.display = 'block'; }
        
        function askJarvis() {
            alert("नमस्ते सुशील! मैं जार्विस हूँ। ultraappstore.com पर आपका स्वागत है। आप यहाँ से VIP ऐप्स डाउनलोड कर सकते हैं।");
        }
    </script>
</body>
</html>

