# HỆ THỐNG KIẾN THỨC VẬT LÍ LỚP 11 (FULL HK1 & HK2)

---

## HỌC KỲ 1: DAO ĐỘNG VÀ SÓNG

### I. Dao động cơ

#### 1. Dao động điều hòa
*   **Khái niệm:** Dao động điều hòa là dao động trong đó li độ của vật là một hàm sin hoặc cosin của thời gian.
*   **Phương trình dao động điều hòa:**
    $$x = A\cos(\omega t + \phi)$$
    *   $x$: Li độ (độ lệch khỏi vị trí cân bằng - $\text{m}$ hoặc $\text{cm}$).
    *   $A$: Biên độ dao động ($A > 0$, là li độ cực đại).
    *   $\omega$: Tần số góc ($\text{rad/s}$), đặc trưng cho tốc độ biến thiên của pha.
    *   $(\omega t + \phi)$: Pha của dao động tại thời điểm $t$ ($\text{rad}$).
    *   $\phi$: Pha ban đầu tại $t = 0$ ($-\pi \le \phi \le \pi$).
*   **Chu kì, tần số và mối liên hệ:**
    *   Chu kì ($T$): Thời gian để vật thực hiện một dao động toàn phần. $T = \frac{2\pi}{\omega}$ ($\text{s}$).
    *   Tần số ($f$): Số dao động toàn phần thực hiện được trong một giây. $f = \frac{1}{T} = \frac{\omega}{2\pi}$ ($\text{Hz}$).

#### 2. Vận tốc và gia tốc trong dao động điều hòa
*   **Phương trình vận tốc:** $v = x' = -\omega A\sin(\omega t + \phi) = \omega A\cos(\omega t + \phi + \frac{\pi}{2})$
    *   Vận tốc biến thiên điều hòa cùng tần số nhưng **sớm pha $\frac{\pi}{2}$** so với li độ.
    *   Vật qua vị trí cân bằng ($x = 0$): Vận tốc có độ lớn cực đại $v_{max} = \omega A$.
    *   Vật ở vị trí biên ($x = \pm A$): Vận tốc bằng 0.
*   **Phương trình gia tốc:** $a = v' = x'' = -\omega^2 A\cos(\omega t + \phi) = -\omega^2 x$
    *   Gia tốc biến thiên điều hòa cùng tần số nhưng **ngược pha** so với li độ (sớm pha $\frac{\pi}{2}$ so với vận tốc).
    *   Vật qua vị trí cân bằng ($x = 0$): Gia tốc bằng 0.
    *   Vật ở vị trí biên ($x = \pm A$): Gia tốc có độ lớn cực đại $a_{max} = \omega^2 A$ và luôn hướng về vị trí cân bằng.
*   **Hệ thức độc lập với thời gian:**
    $$A^2 = x^2 + \frac{v^2}{\omega^2} = \frac{a^2}{\omega^4} + \frac{v^2}{\omega^2}$$

#### 3. Năng lượng trong dao động điều hòa
*   **Động năng:** $W_đ = \frac{1}{2}mv^2 = \frac{1}{2}m\omega^2 A^2\sin^2(\omega t + \phi)$
*   **Thế năng:** $W_t = \frac{1}{2}m\omega^2 x^2 = \frac{1}{2}m\omega^2 A^2\cos^2(\omega t + \phi)$
*   **Cơ năng:** $W = W_đ + W_t = \frac{1}{2}m\omega^2 A^2 = \text{const}$ (được bảo toàn nếu bỏ qua mọi ma sát).
*   *Lưu ý:* Khi li độ và vận tốc biến thiên điều hòa với chu kì $T$, tần số $f$ thì động năng và thế năng biến thiên tuần hoàn với chu kì $T' = \frac{T}{2}$ và tần số $f' = 2f$.

#### 4. Dao động tắt dần, dao động cưỡng bức và Hiện tượng cộng hưởng
*   **Dao động tắt dần:** Là dao động có biên độ và cơ năng giảm dần theo thời gian do tác dụng của lực cản môi trường. Lực cản càng lớn, dao động tắt dần càng nhanh.
*   **Dao động duy trì:** Bằng cách cung cấp thêm năng lượng đúng bằng phần năng lượng tiêu hao sau mỗi chu kì mà không làm thay đổi chu kì riêng của hệ.
*   **Dao động cưỡng bức:** Là dao động chịu tác dụng của một ngoại lực tuần hoàn biến đổi theo thời gian $F = F_0\cos(\omega t + \phi_0)$. Dao động cưỡng bức có tần số bằng tần số của ngoại lực cưỡng bức.
*   **Hiện tượng cộng hưởng:** Là hiện tượng biên độ của dao động cưỡng bức tăng nhanh đến giá trị cực đại khi tần số của lực cưỡng bức bằng hoặc xấp xỉ bằng tần số dao động riêng của hệ ($\omega = \omega_0$).

### II. Sóng cơ và Sóng âm

#### 1. Sóng cơ và các đặc trưng của sóng
*   **Khái niệm:** Sóng cơ là sự lan truyền dao động cơ trong một môi trường vật chất theo thời gian. Các phần tử môi trường chỉ dao động tại chỗ chứ không truyền đi theo sóng.
*   **Phân loại:**
    *   *Sóng ngang:* Các phần tử môi trường dao động theo phương **vuông góc** với phương truyền sóng (Truyền được trong chất rắn và bề mặt chất lỏng).
    *   *Sóng dọc:* Các phần tử môi trường dao động theo phương **trùng với** phương truyền sóng (Truyền được trong cả chất rắn, lỏng, khí).
*   **Các đại lượng đặc trưng:**
    *   Biên độ sóng ($A$), Chu kì ($T$), Tần số ($f$).
    *   Tốc độ truyền sóng ($v$): Tốc độ lan truyền dao động trong môi trường (Phụ thuộc vào bản chất môi trường: $v_{rắn} > v_{lỏng} > v_{khí}$).
    *   Bước sóng ($\lambda$): Quãng đường sóng truyền được trong một chu kì, hoặc là khoảng cách ngắn nhất giữa hai điểm trên cùng một phương truyền sóng dao động cùng pha.
        $$\lambda = v \cdot T = \frac{v}{f}$$
*   **Phương trình sóng:** Nếu nguồn $O$ dao động với phương trình $u_O = A\cos(\omega t)$ thì phương trình sóng tại điểm $M$ cách $O$ một khoảng $x$ trên phương truyền sóng là:
    $$u_M = A\cos\left(\omega t - \frac{2\pi x}{\lambda}\right)$$
*   **Độ lệch pha giữa hai điểm cách nhau khoảng $d$ trên cùng một phương truyền:** $\Delta \phi = \frac{2\pi d}{\lambda}$.

#### 2. Giao thoa sóng và Sóng dừng
*   **Giao thoa sóng:** Là hiện tượng hai sóng kết hợp (cùng tần số và có độ lệch pha không đổi theo thời gian) gặp nhau tạo nên các cực đại và cực tiểu giao thoa ổn định trong không gian.
    *   Vị trí cực đại giao thoa: $d_2 - d_1 = k\lambda$ ($k \in \mathbb{Z}$).
    *   Vị trí cực tiểu giao thoa: $d_2 - d_1 = (k + \frac{1}{2})\lambda$ ($k \in \mathbb{Z}$).
*   **Sóng dừng:** Là sóng có các nút sóng (điểm luôn đứng yên) và bụng sóng (điểm luôn dao động với biên độ cực đại) cố định trong không gian do sự giao thoa giữa sóng tới và sóng phản xạ.
    *   Khoảng cách giữa 2 nút liên tiếp hoặc 2 bụng liên tiếp bằng $\frac{\lambda}{2}$. Khoảng cách giữa 1 nút và 1 bụng liên tiếp bằng $\frac{\lambda}{4}$.
    *   *Điều kiện có sóng dừng:*
        *   Hai đầu cố định: $L = k\frac{\lambda}{2}$ ($k$ là số bụng sóng, số nút = $k + 1$).
        *   Một đầu cố định, một đầu tự do: $L = (2k + 1)\frac{\lambda}{4}$ ($k$ là số bụng hoặc số nút).

---

## HỌC KỲ 2: ĐIỆN TRƯỜNG VÀ DÒNG ĐIỆN KHÔNG ĐỔI

### I. Điện trường

#### 1. Lực tương tác tĩnh điện (Định luật Culông)
*   Lực hút hoặc đẩy giữa hai điện tích điểm $q_1, q_2$ đặt trong chân không tỉ lệ thuận với tích độ lớn của hai điện tích và tỉ lệ nghịch với bình phương khoảng cách giữa chúng.
    $$F = k \cdot \frac{|q_1 \cdot q_2|}{r^2}$$
    *   Trong đó: $k = 9 \cdot 10^9 \, \text{N.m}^2/\text{C}^2$, $r$ là khoảng cách ($\text{m}$).
    *   Nếu đặt trong môi trường điện môi đồng tính có hằng số điện môi $\varepsilon$: $F = k \cdot \frac{|q_1 \cdot q_2|}{\varepsilon \cdot r^2}$.

#### 2. Cường độ điện trường
*   **Khái niệm:** Là đại lượng đặc trưng cho điện trường về mặt tác dụng lực. $\vec{E} = \frac{\vec{F}}{q}$ (Đơn vị: $\text{V/m}$).
*   **Điện trường của một điện tích điểm $Q$:**
    $$E = k \cdot \frac{|Q|}{\varepsilon \cdot r^2}$$
    *   Nếu $Q > 0$: $\vec{E}$ hướng ra xa điện tích. Nếu $Q < 0$: $\vec{E}$ hướng về phía điện tích.
*   **Nguyên lí chồng chất điện trường:** $\vec{E} = \vec{E}_1 + \vec{E}_2 + ... + \vec{E}_n$.

#### 3. Công của lực điện, Điện thế và Hiệu điện thế
*   **Công của lực điện:** Không phụ thuộc vào hình dạng đường đi mà chỉ phụ thuộc vào vị trí điểm đầu và điểm cuối của đường đi trong điện trường.
    $$A_{MN} = q \cdot E \cdot d$$
    *   $d$: Hình chiếu của quỹ đạo lên một đường sức điện ($\text{m}$).
*   **Hiệu điện thế và liên hệ với cường độ điện trường đều:**
    $$U_{MN} = V_M - V_V = \frac{A_{MN}}{q} \quad \text{và} \quad E = \frac{U}{d}$$

#### 4. Tụ điện
*   **Khái niệm:** Là một hệ hai vật dẫn đặt gần nhau và ngăn cách nhau bằng một lớp cách điện (điện môi), dùng để tích và phóng điện.
*   **Điện dung của tụ điện ($C$):** Đại lượng đặc trưng cho khả năng tích điện của tụ.
    $$C = \frac{Q}{U}$$ (Đơn vị: Fara - $\text{F}$).
*   **Năng lượng điện trường bên trong tụ điện:** $W = \frac{1}{2}Q \cdot U = \frac{1}{2}C \cdot U^2 = \frac{1}{2}\frac{Q^2}{C}$.

### II. Dòng điện không đổi

#### 1. Dòng điện và Cường độ dòng điện
*   **Dòng điện:** Dòng dịch chuyển có hướng của các hạt mang điện (điện tích).
*   **Cường độ dòng điện ($I$):** Đại lượng đặc trưng cho tác dụng mạnh hay yếu của dòng điện, đo bằng điện lượng dịch chuyển qua tiết diện thẳng của vật dẫn trong một đơn vị thời gian.
    $$I = \frac{\Delta q}{\Delta t}$$ (Đơn vị: Ampe - $\text{A}$).
    *   *Dòng điện không đổi:* Có chiều và cường độ không thay đổi theo thời gian: $I = \frac{q}{t}$.
*   **Nguồn điện và Suất điện động:**
    *   Nguồn điện duy trì hiệu điện thế giữa hai cực của nó nhờ các lực lạ bên trong nguồn làm dịch chuyển các điện tích.
    *   Suất điện động ($\mathcal{E}$) của nguồn điện đặc trưng cho khả năng thực hiện công của nguồn điện:
        $$\mathcal{E} = \frac{A_{lạ}}{q}$$ (Đơn vị: Vôn - $\text{V}$). Mỗi nguồn điện có suất điện động $\mathcal{E}$ và điện trở trong $r$.

#### 2. Định luật Ôm đối với toàn mạch
*   Cường độ dòng điện chạy trong mạch điện kín tỉ lệ thuận với suất điện động của nguồn điện và tỉ lệ nghịch với điện trở toàn phần của mạch đó.
    $$I = \frac{\mathcal{E}}{R_{nguài} + r}$$
*   **Hiệu điện thế mạch ngoài (độ sụt áp mạch ngoài):** $U = I \cdot R_{nguài} = \mathcal{E} - I \cdot r$.
*   **Hiện tượng đoản mạch:** Xảy ra khi điện trở mạch ngoài không đáng kể ($R_{nguài} \approx 0$). Khi đó cường độ dòng điện trong mạch đạt giá trị cực đại $I_{max} = \frac{\mathcal{E}}{r}$, có thể gây cháy nổ, hỏng hóc nguồn điện.

#### 3. Công và Công suất của nguồn điện
*   **Công của nguồn điện:** $A_{nguồn} = q \cdot \mathcal{E} = \mathcal{E} \cdot I \cdot t$.
*   **Công suất của nguồn điện:** $P_{nguồn} = \frac{A_{nguồn}}{t} = \mathcal{E} \cdot I$.
*   **Hiệu suất của nguồn điện:**
    $$H = \frac{A_{ích}}{A_{tp}} = \frac{U \cdot I \cdot t}{\mathcal{E} \cdot I \cdot t} = \frac{U}{\mathcal{E}} = \frac{R_{nguài}}{R_{nguài} + r}$$
