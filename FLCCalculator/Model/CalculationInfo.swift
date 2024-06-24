import UIKit

struct CalculationInfo {
    static let chinaLocations = [
        FLCPickerItem(title: "Anji (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Anlu (Hubei)", subtitle: "", image: nil),
        FLCPickerItem(title: "Anping (Hebei)", subtitle: "", image: nil),
        FLCPickerItem(title: "Anqing (Anhui)", subtitle: "", image: nil),
        FLCPickerItem(title: "Anshan (Liaoning)", subtitle: "", image: nil),
        FLCPickerItem(title: "Anyang (Henan)", subtitle: "", image: nil),
        FLCPickerItem(title: "Baoding (Hebei)", subtitle: "", image: nil),
        FLCPickerItem(title: "Baoshan (Shanghai)", subtitle: "", image: nil),
        FLCPickerItem(title: "Baoying (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Beijing (Beijing)", subtitle: "", image: nil),
        FLCPickerItem(title: "Bengbu (Anhui)", subtitle: "", image: nil),
        FLCPickerItem(title: "Benxi (Liaoning)", subtitle: "", image: nil),
        FLCPickerItem(title: "Binhai (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Binzhou (Shandong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Cangzhou (Hebei)", subtitle: "", image: nil),
        FLCPickerItem(title: "Changde (Hunan)", subtitle: "", image: nil),
        FLCPickerItem(title: "Changshu (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Chanzhou (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Chaoyang (Liaoning)", subtitle: "", image: nil),
        FLCPickerItem(title: "Chaozhou (Guangdong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Chizhou (Anhui)", subtitle: "", image: nil),
        FLCPickerItem(title: "Chongqing (Chongqing)", subtitle: "", image: nil),
        FLCPickerItem(title: "Cixi (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Dalian (Liaoning)", subtitle: "", image: nil),
        FLCPickerItem(title: "Dandong (Liaoning)", subtitle: "", image: nil),
        FLCPickerItem(title: "Danyang (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Deqing (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Dezhou (Shandong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Dingzhou (Hebei)", subtitle: "", image: nil),
        FLCPickerItem(title: "Dongguan (Guangdong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Dongyang (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Dongying (Shandong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Fengxian (Shanghai)", subtitle: "", image: nil),
        FLCPickerItem(title: "Foshan (Guangdong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Fuan (Fujian)", subtitle: "", image: nil),
        FLCPickerItem(title: "Fuxin (Liaoning)", subtitle: "", image: nil),
        FLCPickerItem(title: "Fuyang (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Fuyang (Anhui)", subtitle: "", image: nil),
        FLCPickerItem(title: "Fuzhou (Fujian)", subtitle: "", image: nil),
        FLCPickerItem(title: "Guangzhou (Guangdong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Haiyan (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Handan (Hebei)", subtitle: "", image: nil),
        FLCPickerItem(title: "Hangzhou (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Hebi (Henan)", subtitle: "", image: nil),
        FLCPickerItem(title: "Hefei (Anhui)", subtitle: "", image: nil),
        FLCPickerItem(title: "Heze (Shandong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Huaian (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Huangshan (Anhui)", subtitle: "", image: nil),
        FLCPickerItem(title: "Huizhou (Guangdong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Huludao (Liaoning)", subtitle: "", image: nil),
        FLCPickerItem(title: "Huzhou (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Jiading (Shanghai)", subtitle: "", image: nil),
        FLCPickerItem(title: "Jiande (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Jiangmen (Guangdong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Jiangyan (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Jiangying (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Jiaozuo (Henan)", subtitle: "", image: nil),
        FLCPickerItem(title: "Jiashan (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Jiaxing (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Jinan (Shandong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Jincheng (Shanxi)", subtitle: "", image: nil),
        FLCPickerItem(title: "Jinhu (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Jinhua (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Jining (Shandong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Jinjiang (Fujian)", subtitle: "", image: nil),
        FLCPickerItem(title: "Jinshan (Shanghai)", subtitle: "", image: nil),
        FLCPickerItem(title: "Jintan (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Jinzhou (Liaoning)", subtitle: "", image: nil),
        FLCPickerItem(title: "Jurong (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Kaifeng (Henan)", subtitle: "", image: nil),
        FLCPickerItem(title: "Kunshan (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Langfang (Hebei)", subtitle: "", image: nil),
        FLCPickerItem(title: "Lianyungang (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Liaocheng (Shandong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Liaoyang (Liaoning)", subtitle: "", image: nil),
        FLCPickerItem(title: "Linan (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Linqing (Shandong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Linyi (Shandong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Lishui (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Liuan (Anhui)", subtitle: "", image: nil),
        FLCPickerItem(title: "Liyang (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Longyan (Fujian)", subtitle: "", image: nil),
        FLCPickerItem(title: "Luoyang (Henan)", subtitle: "", image: nil),
        FLCPickerItem(title: "Maanshan (Anhui)", subtitle: "", image: nil),
        FLCPickerItem(title: "Maoming (Guangdong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Nanjing (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Nanping (Fujian)", subtitle: "", image: nil),
        FLCPickerItem(title: "Nantong (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Nanyang (Henan)", subtitle: "", image: nil),
        FLCPickerItem(title: "Ningbo (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Ningde (Fujian)", subtitle: "", image: nil),
        FLCPickerItem(title: "Panjin (Liaoning)", subtitle: "", image: nil),
        FLCPickerItem(title: "Pinghu (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Pudong (Shanghai)", subtitle: "", image: nil),
        FLCPickerItem(title: "Putian (Fujian)", subtitle: "", image: nil),
        FLCPickerItem(title: "Qidong (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Qingdao (Shandong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Qinhuangdao (Hebei)", subtitle: "", image: nil),
        FLCPickerItem(title: "Quanzhou (Fujian)", subtitle: "", image: nil),
        FLCPickerItem(title: "Quzhou (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Rizhao (Shandong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Rugao (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Sanmenxia (Henan)", subtitle: "", image: nil),
        FLCPickerItem(title: "Sanming (Fujian)", subtitle: "", image: nil),
        FLCPickerItem(title: "Shangqiu (Henan)", subtitle: "", image: nil),
        FLCPickerItem(title: "Shangyu (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Shantou (Guangdong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Shaoguan (Guangdong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Shaoxing (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Shenyang (Liaoning)", subtitle: "", image: nil),
        FLCPickerItem(title: "Shenzhen (Guangdong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Shijiazhuang (Hebei)", subtitle: "", image: nil),
        FLCPickerItem(title: "Shishi (Fujian)", subtitle: "", image: nil),
        FLCPickerItem(title: "Shiyan (Hubei)", subtitle: "", image: nil),
        FLCPickerItem(title: "Songjiang (Shanghai)", subtitle: "", image: nil),
        FLCPickerItem(title: "Suqian (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Suzhou (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Taian (Shandong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Taicang (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Taizhou (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Taizhou (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Tanshan (Hebei)", subtitle: "", image: nil),
        FLCPickerItem(title: "Tengzhou (Shandong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Tianjin (Tianjin)", subtitle: "", image: nil),
        FLCPickerItem(title: "Tongling (Anhui)", subtitle: "", image: nil),
        FLCPickerItem(title: "Tonglu (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Weifang (Shandong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Weihai (Shandong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Wenling (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Wenzhou (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Wuhu (Anhui)", subtitle: "", image: nil),
        FLCPickerItem(title: "Wujiang (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Wushun (Liaoning)", subtitle: "", image: nil),
        FLCPickerItem(title: "Wuxi (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Wuzhou (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Xiamen (Fujian)", subtitle: "", image: nil),
        FLCPickerItem(title: "Xian (Shanxi)", subtitle: "", image: nil),
        FLCPickerItem(title: "Xiaoshan (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Xingtai (Hebei)", subtitle: "", image: nil),
        FLCPickerItem(title: "Xinxiang (Henan)", subtitle: "", image: nil),
        FLCPickerItem(title: "Xinyang (Henan)", subtitle: "", image: nil),
        FLCPickerItem(title: "Xuancheng (Anhui)", subtitle: "", image: nil),
        FLCPickerItem(title: "Xuzhou (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Yancheng (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Yangzhou (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Yantai (Shandong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Yingkou (Liaoning)", subtitle: "", image: nil),
        FLCPickerItem(title: "Yiwu (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Yixing (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Yueqing (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Yunfu (Guangdong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Yuyao (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Zaozhuang (Shandong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Zhangjiagang (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Zhangjiakou (Hebei)", subtitle: "", image: nil),
        FLCPickerItem(title: "Zhangzhou (Fujian)", subtitle: "", image: nil),
        FLCPickerItem(title: "Zhanjiang (Guangdong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Zhengzhou (Henan)", subtitle: "", image: nil),
        FLCPickerItem(title: "Zhenjiang (Jiangsu)", subtitle: "", image: nil),
        FLCPickerItem(title: "Zhongshan (Guangdong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Zhoukou (Henan)", subtitle: "", image: nil),
        FLCPickerItem(title: "Zhoushan (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Zhuhai (Guangdong)", subtitle: "", image: nil),
        FLCPickerItem(title: "Zhuji (Zhejiang)", subtitle: "", image: nil),
        FLCPickerItem(title: "Zhumadian (Henan)", subtitle: "", image: nil),
        FLCPickerItem(title: "Zhuzhou (Hunan)", subtitle: "", image: nil),
        FLCPickerItem(title: "Zibo (Shandong)", subtitle: "", image: nil)
    ]
    
    static let turkeyLocations = [
        FLCPickerItem(title: "Konya (42160)", subtitle: "", image: nil),
        FLCPickerItem(title: "Mersin (33060)", subtitle: "", image: nil),
        FLCPickerItem(title: "Adana (01110)", subtitle: "", image: nil),
        FLCPickerItem(title: "Gaziantep (27620)", subtitle: "", image: nil),
        FLCPickerItem(title: "K.Maras (46140)", subtitle: "", image: nil),
        FLCPickerItem(title: "Hatay (31000)", subtitle: "", image: nil),
        FLCPickerItem(title: "Kayseri (38170)", subtitle: "", image: nil),
        FLCPickerItem(title: "Ankara (06980)", subtitle: "", image: nil),
        FLCPickerItem(title: "Kazan (06000)", subtitle: "", image: nil),
        FLCPickerItem(title: "Eskisehir (26000)", subtitle: "", image: nil),
        FLCPickerItem(title: "Balikesir (10100)", subtitle: "", image: nil),
        FLCPickerItem(title: "Bursa (16450)", subtitle: "", image: nil),
        FLCPickerItem(title: "Gemlik (16600)", subtitle: "", image: nil),
        FLCPickerItem(title: "Gebze (41400)", subtitle: "", image: nil),
        FLCPickerItem(title: "Kocaeli (Izmit) (41200)", subtitle: "", image: nil),
        FLCPickerItem(title: "Sakarya (54580)", subtitle: "", image: nil),
        FLCPickerItem(title: "Izmir (35220)", subtitle: "", image: nil),
        FLCPickerItem(title: "Manisa (45110)", subtitle: "", image: nil),
        FLCPickerItem(title: "Denizli (20040)", subtitle: "", image: nil),
        FLCPickerItem(title: "Antalya (07070)", subtitle: "", image: nil),
        FLCPickerItem(title: "Mugla (48000)", subtitle: "", image: nil),
        FLCPickerItem(title: "Aydin (09000)", subtitle: "", image: nil),
        FLCPickerItem(title: "Malatya (44900)", subtitle: "", image: nil),
        FLCPickerItem(title: "Tekirdag (59000)", subtitle: "", image: nil),
        FLCPickerItem(title: "Duzce (81100)", subtitle: "", image: nil),
        FLCPickerItem(title: "Yalova (77200)", subtitle: "", image: nil),
        FLCPickerItem(title: "Corlu (59850)", subtitle: "", image: nil),
        FLCPickerItem(title: "Istanbul", subtitle: "", image: nil)
    ]
    
    static let istanbulLocations = [
        FLCPickerItem(title: "Esenyurt (34517)", subtitle: "", image: nil),
        FLCPickerItem(title: "Avcilar (34310)", subtitle: "", image: nil),
        FLCPickerItem(title: "Beylikduzu (34520)", subtitle: "", image: nil),
        FLCPickerItem(title: "Buyukcekmece (34500)", subtitle: "", image: nil),
        FLCPickerItem(title: "Catalca (34540)", subtitle: "", image: nil),
        FLCPickerItem(title: "Kirac (34517)", subtitle: "", image: nil),
        FLCPickerItem(title: "Hadimkoy (34555)", subtitle: "", image: nil),
        FLCPickerItem(title: "Kucukcekmece (34290)", subtitle: "", image: nil),
        FLCPickerItem(title: "Gunesli (34212)", subtitle: "", image: nil),
        FLCPickerItem(title: "Yenibosna (34197)", subtitle: "", image: nil),
        FLCPickerItem(title: "Ikitelli (34306)", subtitle: "", image: nil),
        FLCPickerItem(title: "Sefakoy (34295)", subtitle: "", image: nil),
        FLCPickerItem(title: "Bagcilar (34200)", subtitle: "", image: nil),
        FLCPickerItem(title: "Mahmutbey (34217)", subtitle: "", image: nil),
        FLCPickerItem(title: "Yesilkoy (34149)", subtitle: "", image: nil),
        FLCPickerItem(title: "Halkali (34303)", subtitle: "", image: nil),
        FLCPickerItem(title: "Zeytinburnu (34020)", subtitle: "", image: nil),
        FLCPickerItem(title: "Arnavutkoy (34283)", subtitle: "", image: nil),
        FLCPickerItem(title: "Bakirkoy (34140)", subtitle: "", image: nil),
        FLCPickerItem(title: "Basaksehir (34480)", subtitle: "", image: nil),
        FLCPickerItem(title: "Topkari (34093)", subtitle: "", image: nil),
        FLCPickerItem(title: "Eyup (34076)", subtitle: "", image: nil),
        FLCPickerItem(title: "Alibeykoy (34060)", subtitle: "", image: nil),
        FLCPickerItem(title: "Bayrampasa (34035)", subtitle: "", image: nil),
        FLCPickerItem(title: "Rami (34055)", subtitle: "", image: nil),
        FLCPickerItem(title: "Halic (59300)", subtitle: "", image: nil),
        FLCPickerItem(title: "Kemerburgaz (34075)", subtitle: "", image: nil),
        FLCPickerItem(title: "Gaziosmanpasa (34250)", subtitle: "", image: nil),
        FLCPickerItem(title: "Silivri (34580)", subtitle: "", image: nil),
        FLCPickerItem(title: "Sariyer (34450)", subtitle: "", image: nil),
        FLCPickerItem(title: "Caglayan (34403)", subtitle: "", image: nil),
        FLCPickerItem(title: "Sutluce (34445)", subtitle: "", image: nil),
        FLCPickerItem(title: "Ayazaga (34396)", subtitle: "", image: nil),
        FLCPickerItem(title: "Kagithane (34400)", subtitle: "", image: nil),
        FLCPickerItem(title: "Okmeydani (34384)", subtitle: "", image: nil),
        FLCPickerItem(title: "Seyrantepe (34418)", subtitle: "", image: nil),
        FLCPickerItem(title: "Maslak (34485)", subtitle: "", image: nil),
        FLCPickerItem(title: "Besiktas (34345)", subtitle: "", image: nil),
        FLCPickerItem(title: "Tarabya (34457)", subtitle: "", image: nil),
        FLCPickerItem(title: "Etiler (34337)", subtitle: "", image: nil),
        FLCPickerItem(title: "Istinye (34460)", subtitle: "", image: nil),
        FLCPickerItem(title: "Baltalimani (34470)", subtitle: "", image: nil),
        FLCPickerItem(title: "Malkara, Tekirdag (59300)", subtitle: "", image: nil),
        FLCPickerItem(title: "Kavacik (34810)", subtitle: "", image: nil),
        FLCPickerItem(title: "Beykoz (34820)", subtitle: "", image: nil),
        FLCPickerItem(title: "Acibadem (34460)", subtitle: "", image: nil),
        FLCPickerItem(title: "Kozyatagi (34742)", subtitle: "", image: nil),
        FLCPickerItem(title: "Uskudar (34672)", subtitle: "", image: nil),
        FLCPickerItem(title: "Goztepe (34730)", subtitle: "", image: nil),
        FLCPickerItem(title: "Atasehir (34750)", subtitle: "", image: nil),
        FLCPickerItem(title: "Sarigazi (34785)", subtitle: "", image: nil),
        FLCPickerItem(title: "Samandira (34885)", subtitle: "", image: nil),
        FLCPickerItem(title: "Sultanbeyli (34920)", subtitle: "", image: nil),
        FLCPickerItem(title: "Dudullu (34773)", subtitle: "", image: nil),
        FLCPickerItem(title: "Umraniye (34760)", subtitle: "", image: nil),
        FLCPickerItem(title: "Kartal (34876)", subtitle: "", image: nil),
        FLCPickerItem(title: "Maltepe (34844)", subtitle: "", image: nil),
        FLCPickerItem(title: "Sancaktepe (34885)", subtitle: "", image: nil),
        FLCPickerItem(title: "Cekmekoy (34798)", subtitle: "", image: nil),
        FLCPickerItem(title: "Tuzla (34959)", subtitle: "", image: nil),
        FLCPickerItem(title: "Kurtkoy (34912)", subtitle: "", image: nil),
        FLCPickerItem(title: "Orhanli (34956)", subtitle: "", image: nil),
        FLCPickerItem(title: "Pendik (34890)", subtitle: "", image: nil),
        FLCPickerItem(title: "Gebze (41400)", subtitle: "", image: nil),
        FLCPickerItem(title: "Pelitli (41480)", subtitle: "", image: nil),
        FLCPickerItem(title: "Cayirova, Kocaeli (41435)", subtitle: "", image: nil),
        FLCPickerItem(title: "Sekerpinar, Kocaeli (41435)", subtitle: "", image: nil)
    ]
    
    static let categories: [FLCPickerItem] = [
        FLCPickerItem(title: "Авто-аксессуары", subtitle: "Cигнализации, автомагнитолы и т.д.", image: nil),
        FLCPickerItem(title: "Автозапчасти", subtitle: "", image: nil),
        FLCPickerItem(title: "Аксессуары (одежда)", subtitle: "Перчатки, галстуки, шарфы, платки, гол.уборы", image: nil),
        FLCPickerItem(title: "Бельё", subtitle: "", image: nil),
        FLCPickerItem(title: "Аксессуары", subtitle: "", image: nil),
        FLCPickerItem(title: "Антенны", subtitle: "И аксессуары", image: nil),
        FLCPickerItem(title: "Бассейны, сауны, бани", subtitle: "Оборудование и аксессуары", image: nil),
        FLCPickerItem(title: "Бижутерия", subtitle: "", image: nil),
        FLCPickerItem(title: "Браслеты, ремешки, футляры", subtitle: "Для часов", image: nil),
        FLCPickerItem(title: "Бисер", subtitle: "", image: nil),
        FLCPickerItem(title: "Бытовые клеи", subtitle: "Красители и др.", image: nil),
        FLCPickerItem(title: "Бытовые насосы", subtitle: "Шланги", image: nil),
        FLCPickerItem(title: "Гладильные доски", subtitle: "Сушилки для белья, стремянки", image: nil),
        FLCPickerItem(title: "Бытовая техника", subtitle: "И электроника", image: nil),
        FLCPickerItem(title: "Галантерея", subtitle: "Нитки, кошельки, ремни, сумки и пр.", image: nil),
        FLCPickerItem(title: "Бытовая мебель для дома", subtitle: "Мягкая мебель, спальни", image: nil),
        FLCPickerItem(title: "Бытовая химия", subtitle: "", image: nil),
        FLCPickerItem(title: "Конструкции для строительства", subtitle: "Готовые и разборные", image: nil),
        FLCPickerItem(title: "Детская мебель", subtitle: "", image: nil),
        FLCPickerItem(title: "Декоративная косметика", subtitle: "", image: nil),
        FLCPickerItem(title: "Душевые и паровые кабины", subtitle: "Гидромассажные ванны", image: nil),
        FLCPickerItem(title: "Детская одежда", subtitle: "", image: nil),
        FLCPickerItem(title: "Детская обувь", subtitle: "", image: nil),
        FLCPickerItem(title: "Елочные украшения", subtitle: "Новогодние и другие праздничные товары", image: nil),
        FLCPickerItem(title: "Дачная и кемпинговая мебель", subtitle: "", image: nil),
        FLCPickerItem(title: "Декоративные изделия", subtitle: "Картины, постеры, эстампы, фонтаны и др.", image: nil),
        FLCPickerItem(title: "Домофоны", subtitle: "", image: nil),
        FLCPickerItem(title: "Игровое оборудование", subtitle: "", image: nil),
        FLCPickerItem(title: "Зеркала", subtitle: "", image: nil),
        FLCPickerItem(title: "Жалюзи", subtitle: "Карнизы, портьеры, шторы", image: nil),
        FLCPickerItem(title: "Запчасти ", subtitle: "Комплектующие к производственному оборудованию", image: nil),
        FLCPickerItem(title: "Запчасти", subtitle: "К торговому оборудованию", image: nil),
        FLCPickerItem(title: "Замочные изделия", subtitle: "Оконная и дверная фурнитура", image: nil),
        FLCPickerItem(title: "Игрушки", subtitle: "Конструкторы, настольные игры и др.", image: nil),
        FLCPickerItem(title: "Канцтовары", subtitle: "Книги, школьные принадлежности", image: nil),
        FLCPickerItem(title: "Инструменты", subtitle: "", image: nil),
        FLCPickerItem(title: "Измерительный инструмент", subtitle: "И приборы", image: nil),
        FLCPickerItem(title: "Климатическое оборудование", subtitle: "Кондиционеры, системы вентиляции, увлажнители, осушители и их комплектующие", image: nil),
        FLCPickerItem(title: "Кладочные материалы", subtitle: "Кирпич, камень, блоки", image: nil),
        FLCPickerItem(title: "Керамическая плитка", subtitle: "Отделочный камень", image: nil),
        FLCPickerItem(title: "Книги", subtitle: "Журналы и другая печатная продукция", image: nil),
        FLCPickerItem(title: "Отопительное оборудование", subtitle: "", image: nil),
        FLCPickerItem(title: "Кожа натуральная", subtitle: "", image: nil),
        FLCPickerItem(title: "Кожзаменители", subtitle: "", image: nil),
        FLCPickerItem(title: "Ковры", subtitle: "Ковровые изделия", image: nil),
        FLCPickerItem(title: "Косметические принадлежности", subtitle: "Маникюрные, бритвенные", image: nil),
        FLCPickerItem(title: "Компьютерные товары", subtitle: "", image: nil),
        FLCPickerItem(title: "Компьютеры, ноутбуки", subtitle: "", image: nil),
        FLCPickerItem(title: "Косметика", subtitle: "Парфюмерия", image: nil),
        FLCPickerItem(title: "Крепежные изделия", subtitle: "Метизы, фитинги", image: nil),
        FLCPickerItem(title: "Крупная бытовая техника", subtitle: "Холодильники, стиральные машины, плиты, вытяжки и др.", image: nil),
        FLCPickerItem(title: "Кухонная мебель", subtitle: "", image: nil),
        FLCPickerItem(title: "Лакокрасочные материалы", subtitle: "Клеи, герметики, антисептики", image: nil),
        FLCPickerItem(title: "Люстры", subtitle: "Торшеры, бра, плафоны бытовые и комплектующие", image: nil),
        FLCPickerItem(title: "Тара и упаковка", subtitle: "", image: nil),
        FLCPickerItem(title: "Материалы для производства", subtitle: "Полиэтилен, листы пластмассы, бумаги", image: nil),
        FLCPickerItem(title: "Масла", subtitle: "Смазки, автокосметика", image: nil),
        FLCPickerItem(title: "Мангалы", subtitle: "Барбекю, грили, коптильни и принадлежности", image: nil),
        FLCPickerItem(title: "Мебель для ресторанов", subtitle: "", image: nil),
        FLCPickerItem(title: "Мебельная фурнитура", subtitle: "Аксессуары и комплектующие", image: nil),
        FLCPickerItem(title: "Медицинское оборудование", subtitle: "", image: nil),
        FLCPickerItem(title: "Мебель", subtitle: "", image: nil),
        FLCPickerItem(title: "Медицинский комплект", subtitle: "", image: nil),
        FLCPickerItem(title: "Мебель и аксессуары", subtitle: "Для ванных комнат", image: nil),
        FLCPickerItem(title: "Мелкая бытовая техника", subtitle: "Пылесосы, обогреватели, утюги, фены, чайники, кофеварки и др.", image: nil),
        FLCPickerItem(title: "Мелкая кожгалантерея", subtitle: "Кошельки, ремни", image: nil),
        FLCPickerItem(title: "Меховые изделия", subtitle: "Шубы, дубленки, муфты, шапки меховые", image: nil),
        FLCPickerItem(title: "Механический инструмент", subtitle: "", image: nil),
        FLCPickerItem(title: "Металлопрокат", subtitle: "Арматура, проволока, сетка", image: nil),
        FLCPickerItem(title: "Навигационные приборы", subtitle: "И оборудование", image: nil),
        FLCPickerItem(title: "Мото- и квадроциклы", subtitle: "Снегоходы", image: nil),
        FLCPickerItem(title: "Музыкальные инструменты", subtitle: "И принадлежности", image: nil),
        FLCPickerItem(title: "Напольные покрытия", subtitle: "Паркет, линолеум, ковролин", image: nil),
        FLCPickerItem(title: "Оборудование, станки", subtitle: "Для металлообрабатывающего и машиностроительного производства", image: nil),
        FLCPickerItem(title: "Оборудование и инвентарь", subtitle: "Для торговли", image: nil),
        FLCPickerItem(title: "Оборудование", subtitle: "Для пищевой промышленности", image: nil),
        FLCPickerItem(title: "Средства связи", subtitle: "И оборудование", image: nil),
        FLCPickerItem(title: "Обои", subtitle: "Самоклеящаяся пленка", image: nil),
        FLCPickerItem(title: "Обувь", subtitle: "", image: nil),
        FLCPickerItem(title: "Оборудование для отопления", subtitle: "Печи, радиаторы", image: nil),
        FLCPickerItem(title: "Оборудование торговое", subtitle: "весы, кассовые аппараты, штрих коды и т.д.", image: nil),
        FLCPickerItem(title: "Полиграфическая продукция", subtitle: "Открытки, календари", image: nil),
        FLCPickerItem(title: "Ограждения, ворота", subtitle: "Решетки, ставни, кованые изделия", image: nil),
        FLCPickerItem(title: "Офисная техника", subtitle: "", image: nil),
        FLCPickerItem(title: "Одежда", subtitle: "", image: nil),
        FLCPickerItem(title: "Охранное оборудование", subtitle: "И аксессуары", image: nil),
        FLCPickerItem(title: "Окна, двери", subtitle: "Перегородки", image: nil),
        FLCPickerItem(title: "Офисная мебель", subtitle: "", image: nil),
        FLCPickerItem(title: "Оборудование охранное", subtitle: "И противопожарное", image: nil),
        FLCPickerItem(title: "Пластиковая мебель", subtitle: "", image: nil),
        FLCPickerItem(title: "Парфюмерия", subtitle: "", image: nil),
        FLCPickerItem(title: "Парики", subtitle: "Шиньоны, накладки", image: nil),
        FLCPickerItem(title: "Предметы интерьера", subtitle: "", image: nil),
        FLCPickerItem(title: "Подарочная упаковка", subtitle: "", image: nil),
        FLCPickerItem(title: "Посуда", subtitle: "", image: nil),
        FLCPickerItem(title: "Постельные принадлежности", subtitle: "Полотенца, скатерти и др.", image: nil),
        FLCPickerItem(title: "Пневмоинструмент", subtitle: "И гидроинструмент", image: nil),
        FLCPickerItem(title: "Прочая галантерея", subtitle: "", image: nil),
        FLCPickerItem(title: "Продукты питания", subtitle: "В потребительской упаковке", image: nil),
        FLCPickerItem(title: "Промышленная химия", subtitle: "", image: nil),
        FLCPickerItem(title: "Оборудование промышленное", subtitle: "И производственное", image: nil),
        FLCPickerItem(title: "Противопожарное оборудование", subtitle: "И аксессуары", image: nil),
        FLCPickerItem(title: "Провода, кабели", subtitle: "", image: nil),
        FLCPickerItem(title: "Прочая бытовая химия", subtitle: "", image: nil),
        FLCPickerItem(title: "Прочая бытовая техника", subtitle: "", image: nil),
        FLCPickerItem(title: "Прочая косметика", subtitle: "", image: nil),
        FLCPickerItem(title: "Прочее торговое оборудование", subtitle: "", image: nil),
        FLCPickerItem(title: "Прочие инструменты", subtitle: "", image: nil),
        FLCPickerItem(title: "Прочее клим. оборудование", subtitle: "", image: nil),
        FLCPickerItem(title: "Прочие отделочные материалы", subtitle: "", image: nil),
        FLCPickerItem(title: "Прочая сантехника", subtitle: "", image: nil),
        FLCPickerItem(title: "Прочие канцтовары", subtitle: "", image: nil),
        FLCPickerItem(title: "Прочие предметы интерьера", subtitle: "", image: nil),
        FLCPickerItem(title: "Прочие товары для детей", subtitle: "", image: nil),
        FLCPickerItem(title: "Прочий текстиль", subtitle: "", image: nil),
        FLCPickerItem(title: "Расходники", subtitle: "Материалы, аксессуары, запчасти, комплектующие к инструментам", image: nil),
        FLCPickerItem(title: "Рекламные материалы", subtitle: "И оборудование (стенды)", image: nil),
        FLCPickerItem(title: "Пряжа", subtitle: "", image: nil),
        FLCPickerItem(title: "Прочие хоз.товары", subtitle: "", image: nil),
        FLCPickerItem(title: "Транспортные средства", subtitle: "Самоходные наземные", image: nil),
        FLCPickerItem(title: "Рыболовные товары", subtitle: "", image: nil),
        FLCPickerItem(title: "Охотничьи товары", subtitle: "", image: nil),
        FLCPickerItem(title: "Санфаянс", subtitle: "Ванны, раковины, унитазы и др.", image: nil),
        FLCPickerItem(title: "Садовая техника", subtitle: "Оборудование и инвентарь", image: nil),
        FLCPickerItem(title: "Сантехника", subtitle: "", image: nil),
        FLCPickerItem(title: "Складское оборудование", subtitle: "И инвентарь", image: nil),
        FLCPickerItem(title: "Смесители", subtitle: "Краны, вентили, трубы, фитинги", image: nil),
        FLCPickerItem(title: "Сейфы", subtitle: "", image: nil),
        FLCPickerItem(title: "Средства ухода за кожей", subtitle: "Туалетное мыло, товары для душа, крема", image: nil),
        FLCPickerItem(title: "Средства радио связи", subtitle: "", image: nil),
        FLCPickerItem(title: "Спортивное питание", subtitle: "", image: nil),
        FLCPickerItem(title: "Стиральные порошки", subtitle: "Чистящие и моющие средства", image: nil),
        FLCPickerItem(title: "Спортивная экипировка", subtitle: "Одежда, обувь", image: nil),
        FLCPickerItem(title: "Средства мобильной связи", subtitle: "И аксессуары", image: nil),
        FLCPickerItem(title: "Спортинвентарь", subtitle: "Велосипеды, коньки, лыжи и др.", image: nil),
        FLCPickerItem(title: "Приборы", subtitle: "Телекоммуникационные и навигационные", image: nil),
        FLCPickerItem(title: "Панели", subtitle: "Стеновые и отделочные, потолки", image: nil),
        FLCPickerItem(title: "Солнцезащитные очки", subtitle: "", image: nil),
        FLCPickerItem(title: "Столовые приборы", subtitle: "Кухонный инвентарь", image: nil),
        FLCPickerItem(title: "Сумки", subtitle: "Чемоданы, портфели", image: nil),
        FLCPickerItem(title: "Строительное оборудование", subtitle: "", image: nil),
        FLCPickerItem(title: "Сварочное оборудование", subtitle: "", image: nil),
        FLCPickerItem(title: "Отделочные материалы", subtitle: "Конструкции и крепежи", image: nil),
        FLCPickerItem(title: "Сыпучие строй материалы", subtitle: "щебень, песок и др.", image: nil),
        FLCPickerItem(title: "Тара, упаковка", subtitle: "", image: nil),
        FLCPickerItem(title: "Гидроизоляционные материалы", subtitle: "Тепло-, шумо-", image: nil),
        FLCPickerItem(title: "Сырье", subtitle: "Для производства бытовой химии", image: nil),
        FLCPickerItem(title: "Текстильные изделия", subtitle: "", image: nil),
        FLCPickerItem(title: "Кисти, краски", subtitle: "Товары для художественного творчества", image: nil),
        FLCPickerItem(title: "Ткани", subtitle: "", image: nil),
        FLCPickerItem(title: "Товары для отдыха", subtitle: "Спорта, охоты, рыбалки", image: nil),
        FLCPickerItem(title: "Швейные товары", subtitle: "Для швейного и прядильного производства", image: nil),
        FLCPickerItem(title: "Термоинструмент", subtitle: "Строительные фены, паяльные лампы, паяльники и др.", image: nil),
        FLCPickerItem(title: "Товары для детей", subtitle: "Манежи, коляски, кровати и др.", image: nil),
        FLCPickerItem(title: "Медицинские товары", subtitle: "", image: nil),
        FLCPickerItem(title: "Туалетная бумага", subtitle: "Бумажные салфетки и полотенца", image: nil),
        FLCPickerItem(title: "Тренажеры", subtitle: "", image: nil),
        FLCPickerItem(title: "Туристическое снаряжение", subtitle: "И инвентарь", image: nil),
        FLCPickerItem(title: "Фурнитура для одежды", subtitle: "Клепки, молнии, этикетки и т.д", image: nil),
        FLCPickerItem(title: "Пищевая пленка", subtitle: "", image: nil),
        FLCPickerItem(title: "Оптические приборы", subtitle: "И принадлежности", image: nil),
        FLCPickerItem(title: "Измерительные приборы", subtitle: "Весы, термометры, барометры и др.", image: nil),
        FLCPickerItem(title: "Хозяйственно-бытовые товары", subtitle: "", image: nil),
        FLCPickerItem(title: "Швейные машины", subtitle: "Вязальные машины, оверлоки", image: nil),
        FLCPickerItem(title: "Чулки", subtitle: "Чулочно-носочные изделия", image: nil),
        FLCPickerItem(title: "Электротовары", subtitle: "", image: nil),
        FLCPickerItem(title: "Часы", subtitle: "", image: nil),
        FLCPickerItem(title: "Электроинструмент", subtitle: "", image: nil),
        FLCPickerItem(title: "Электрооборудование", subtitle: "Лампы", image: nil),
        FLCPickerItem(title: "Электротехнические изделия", subtitle: "Розетки, терморегуляторы и т.д.", image: nil),
        FLCPickerItem(title: "Оборудование электрощитовое", subtitle: "", image: nil)
    ]
    
    static let currencyOptions = [
        FLCPickerItem(title: "RUB", subtitle: "Рубли", image: UIImage(named: "RUB")),
        FLCPickerItem(title: "CNY", subtitle: "Юани", image: UIImage(named: "CNY")),
        FLCPickerItem(title: "TRY", subtitle: "Лиры", image: UIImage(named: "TRY")),
        FLCPickerItem(title: "USD", subtitle: "Доллары", image: UIImage(named: "USD")),
        FLCPickerItem(title: "EUR", subtitle: "Евро", image: UIImage(named: "EUR"))
    ]
    
    static let countriesOptions = [
        FLCPickerItem(title: FLCCountryOption.china.rawValue, subtitle: "", image: UIImage(named: "CNY")),
        FLCPickerItem(title: FLCCountryOption.turkey.rawValue, subtitle: "", image: UIImage(named: "TRY"))
    ]
    
    static let chinaAirportsOptions = [
        FLCPickerItem(title: FLCCities.beijing.rawValue, subtitle: "Международный аэропорт Дасин (PKX)", image: Icons.plane, isOpenForAdd: false),
        FLCPickerItem(title: FLCCities.shanghai.rawValue, subtitle: "Международный аэропорт Пудун (PVG)", image: Icons.plane, isOpenForAdd: false),
        FLCPickerItem(title: FLCCities.guangzhou.rawValue, subtitle: "Международный аэропорт Байюнь (CAN)", image: Icons.plane, isOpenForAdd: false),
        FLCPickerItem(title: FLCCities.shenzhen.rawValue, subtitle: "Международный аэропорт Баоань (SZX)", image: Icons.plane, isOpenForAdd: false)
    ]
    
    static let chinaDeliveryTypes = [
        FLCPickerItem(title: "EXW, Поставщик - Клиент", subtitle: "От поставщика до склада получателя", image: nil),
        FLCPickerItem(title: "EXW, Поставщик - Склад Подольск", subtitle: "От поставщика до склада FLC", image: nil),
        FLCPickerItem(title: "FCA, \(WarehouseStrings.chinaWarehouse) - Клиент", subtitle: "От склада в Китае до склада получателя", image: nil),
        FLCPickerItem(title: "FCA, \(WarehouseStrings.chinaWarehouse) - Склад Подольск", subtitle: "От склада в Китае до склада FLC", image: nil)
    ]
    
    static let turkeyDeliveryTypes = [
        FLCPickerItem(title: "EXW, Поставщик - Клиент", subtitle: "От поставщика до склада получателя", image: nil),
        FLCPickerItem(title: "EXW, Поставщик - Склад Подольск", subtitle: "От поставщика до склада FLC", image: nil),
        FLCPickerItem(title: "FCA, Склад Стамбул - Клиент", subtitle: "От склада в Стамбуле до склада получателя", image: nil),
        FLCPickerItem(title: "FCA, Склад Стамбул - Склад Подольск", subtitle: "От склада в Стамбуле до склада FLC", image: nil)
    ]
    
    static let defaultManager = FLCManager(
        id: 1,
        name: "Igor Volkov",
        position: "Менеджер по привлечению клиентов",
        mobilePhone: "8 (980) 800-21-24",
        landlinePhone: "8 (495) 640-63-55 доб. 609",
        telegram: "igorVolkovFLC",
        whatsapp: "7(980)-800-21-24",
        email: "i.volkov@free-lines.ru",
        avatarRef: "managerPhotos/igorVolkov.png",
        dataDate: "01.05.2024",
        avatarData: UIImage(named: "personPlaceholder")?.pngData()
    )
    
    static let defaultUsefulInfoDocuments: [Document] = [
        Document(title: "Шаблон договора", fileName: "documents/logisticsAgreement.docx", docDate: "12.05.2024"),
        Document(title: "Презентация FLC", fileName: "documents/presentationFLC.pdf", docDate: "12.05.2024"),
        Document(title: "Презентация по Китаю", fileName: "documents/presentationChina.pdf", docDate: "12.05.2024")
    ]
}
