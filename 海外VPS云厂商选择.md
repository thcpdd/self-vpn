# 海外 VPS / 云厂商选择参考

> 整理自网络资料，记录主流美国 CN2 GIA VPS 商家信息，供选型参考。

## 背景

普通海外 VPS 在晚高峰时延迟高、丢包率可达 20% 以上。CN2 GIA 线路回程延迟稳定，体验更好。

CN2 分两种：
- **CN2 GT**：普通版本，高峰期容易拥堵
- **CN2 GIA**：精品级别，全程高优先级通道，晚高峰更稳定

从国内到美国西海岸（洛杉矶、圣何塞），CN2 GIA 正常延迟在 150-180ms 左右。

## 商家概览

| 商家 | 核心特点 | 官网 |
|------|---------|------|
| 搬瓦工 | 老牌服务商，CN2 GIA 线路品质稳定 | [bandwagonhost.com](https://bandwagonhost.com) |
| DMIT | 高性价比 CN2 GIA，提供原生 IP | [dmit.io](https://dmit.io) |
| HostDare | 回程 CN2 GIA 优化，价格偏低 | [hostdare.com](https://hostdare.com) |
| 丽萨主机 | CN2 GIA + CERA 机房高防，美国原生 IP | [lisahost.com](https://lisahost.com) |
| 六六云 | IP 解锁表现好（TikTok / ChatGPT） | 66yun.com |
| TmhHost | 网络稳定，适合建站 | [tmhhost.com](https://tmhhost.com) |
| ByteVirt | 入门门槛低，月付低价 | [bytevirt.com](https://bytevirt.com) |
| OneTechCloud | 三网回程 CN2 GIA，提供原生 IP | [onetechcloud.com](https://onetechcloud.com) |
| AkkoCloud | 三网回程 + 电信去程 CN2 GIA | [akkocloud.com](https://akkocloud.com) |

## 搬瓦工 (BandwagonHost)

- 运营超十年，稳定性有保障
- 后台面板功能完善（一键重装、快照、流量监控）
- 支持支付宝
- CN2 GIA 机房：USCA_6、USCA_9（洛杉矶）

**套餐参考：**

| CPU/内存 | 存储 | 流量/带宽 | 价格 |
|----------|------|-----------|------|
| 2核 / 1GB | 20GB SSD | 1TB / 2.5Gbps | $49.99/季 |
| 3核 / 2GB | 40GB SSD | 2TB / 2.5Gbps | $89.99/季 |
| 4核 / 4GB | 80GB SSD | 3TB / 2.5Gbps | $56.99/月 |
| 6核 / 8GB | 160GB SSD | 5TB / 5Gbps | $86.99/月 |

- 价格中高区间，带宽充足（2.5Gbps 起步）
- USCA_9 旗舰机房，三网回程 CN2 GIA，晚高峰延迟控制好
- 适合不想折腾、对稳定性要求高的用户

## DMIT

- 主打洛杉矶机房，CN2 GIA 核心产品线
- 提供原生 IP，流媒体解锁友好
- 处理器：AN5 系列用 AMD EPYC 9005
- 性价比优于搬瓦工

**套餐参考（AN5 Pro 系列）：**

| 套餐 | CPU/内存 | 存储 | 流量/带宽 | 价格 |
|------|----------|------|-----------|------|
| AN5.Pro.TINY | 1核 / 2GB | 20GB SSD | 1000GB / 1Gbps | $37.99/季 |
| AN5.Pro.Pocket | 2核 / 2GB | 40GB SSD | 1500GB / 4Gbps | $56.70/季 |
| AN5.Pro.STARTER | 2核 / 2GB | 80GB SSD | 3000GB / 10Gbps | $38.90/月 |
| AN5.Pro.MINI | 4核 / 4GB | 80GB SSD | 5000GB / 10Gbps | $76.90/月 |

- 另有价格更低的 AN4 系列
- STARTER 起步 10Gbps 带宽
- 支持自定义内存和存储
- 适合对原生 IP 有需求、预算有限的用户

## HostDare

- 洛杉矶机房，走低价路线
- CN2 GIA 为回程优化（去程直连）
- 年付三四十美元即可用上回程 CN2 GIA

**套餐参考（CSSD 系列）：**

| 套餐 | CPU/内存 | 存储 | 流量/带宽 | 价格 |
|------|----------|------|-----------|------|
| CSSD0 | 1核 / 768MB | 10GB NVMe | 250GB / 30Mbps | $35.99/年 |
| CSSD1 | 1核 / 1GB | 25GB NVMe | 600GB / 50Mbps | $55.99/年 |
| CSSD2 | 2核 / 2GB | 50GB NVMe | 1000GB / 60Mbps | $85.99/年 |
| CSSD3 | 3核 / 4GB | 100GB NVMe | 1500GB / 80Mbps | $26.99/月 |

- CN2 GIA 端口最高 100Mbps，另提供 1000Mbps 国际带宽补充
- 适合轻量使用（博客等），预算有限的用户

## 丽萨主机

- 国人商家，CERA 机房，CN2 GIA + 高防
- 默认 50G DDoS 防御，100G 内秒解
- 六网回程 CN2 GIA（电信、联通、移动、广电、鹏博士、科技网），去程直连
- 美国原生 IP
- 48 小时无条件退款

**套餐参考：**

| 套餐 | CPU/内存 | 存储 | 流量/带宽 | 价格 |
|------|----------|------|-----------|------|
| 进阶版 | 2核 / 2GB | 40GB SSD | 1200GB / 25Mbps | ¥256/季 |
| 豪华版 | 4核 / 4GB | 80GB SSD | 3000GB / 50Mbps | ¥396/月 |

- 适合有高防需求（跨境电商、对外业务站点）的用户

## 六六云

- 国内团队运营
- 原生 IP 支持 TikTok、ChatGPT、Netflix 直接访问
- 三网 CN2 GIA
- 全新 IP 段，被封概率较低

**套餐参考：**

| CPU/内存 | 流量/带宽 | 价格 |
|----------|-----------|------|
| 1核 / 1GB | 800GB / 200Mbps | ¥55/月 |

- 套餐选择单一，适合有平台解锁需求的轻度用户

## TmhHost

- 三网回程 CN2 GIA
- 免备案
- 支持支付宝、微信付款
- 带宽较小（30Mbps 起）

**套餐参考：**

| 套餐 | CPU/内存 | 存储 | 流量/带宽 | 价格 |
|------|----------|------|-----------|------|
| US CN2 GIA #1 | 1核 / 1GB | 10GB SSD | 800GB / 30Mbps | ¥40/月 |
| US CN2 GIA #2 | 1核 / 2GB | 20GB SSD | 1000GB / 30Mbps | ¥55/月 |
| US CN2 GIA #3 | 2核 / 2GB | 30GB SSD | 1500GB / 30Mbps | ¥75/月 |
| US CN2 GIA #4 | 2核 / 4GB | 40GB SSD | 2000GB / 50Mbps | ¥105/月 |

- 适合个人博客、企业展示站、小型电商

## ByteVirt

- 洛杉矶 CN2 GIA，低价入门路线
- 带宽 500Mbps 起
- 自带快照和备份
- KVM 虚拟化，支持 IPv4 + IPv6 双栈

**套餐参考：**

| 套餐 | CPU/内存 | 存储 | 流量/带宽 | 价格 |
|------|----------|------|-----------|------|
| VPS-512-KVM | 1核 / 512MB | 15GB SSD | 500GB / 500Mbps | $6.05/月 |
| VPS-1024-KVM | 1核 / 1GB | 20GB SSD | 1TB / 500Mbps | $8.80/月 |
| VPS-2048-KVM | 2核 / 2GB | 40GB SSD | 2TB / 500Mbps | $18.15/月 |
| VPS-2C4G40G1T-KVM | 2核 / 4GB | 40GB SSD | 1TB / 500Mbps | $17.60/月 |

- 小商家，库存有限，适合低成本试水、轻量使用

## OneTechCloud（易科云）

- 去程直连，回程三网 CN2 GIA
- 美国原生 IP
- 支持人民币结算

**套餐参考：**

| 套餐 | CPU/内存 | 存储 | 流量/带宽 | 价格 |
|------|----------|------|-----------|------|
| US 1C/512m A1 | 1核 / 512MB | 20GB SSD | 600GB / 50Mbps | ¥38/月 |
| US 1C1G B1 | 1核 / 1GB | 30GB SSD | 1000GB / 50Mbps | ¥58/月 |
| US 2C2G C1 | 2核 / 2GB | 30GB SSD | 2000GB / 60Mbps | ¥118/月 |
| US 4C4G D1 | 4核 / 4GB | 50GB SSD | 4000GB / 80Mbps | ¥228/月 |

- A1 套餐 512MB 自动升 1GB 内存
- 无防御机型，不适合对抗攻击有要求的业务
- 适合流媒体访问、个人服务、轻量建站

## AkkoCloud

- 美西圣何塞机房
- 三网回程 CN2 GIA + 电信去程 CN2 GIA
- 提供 Looking Glass 可供购买前自测
- 支持人民币结算

**套餐参考：**

| 套餐 | CPU/内存 | 存储 | 流量/带宽 | 价格 |
|------|----------|------|-----------|------|
| KVM-CN2-A1 | 1核 / 1GB | 10GB SSD | 600GB 双向 / 500Mbps | ¥50/月 |
| KVM-CN2-A2 | 1核 / 1GB | 15GB SSD | 1000GB 双向 / 500Mbps | ¥75/月 |
| KVM-CN2-A1 mini 季付 | 1核 / 1GB | 10GB SSD | 500GB 双向 / 500Mbps | ¥99/季 |
| KVM-CN2-A2 mini 季付 | 1核 / 1GB | 15GB SSD | 800GB 双向 / 500Mbps | ¥149/季 |

- 适合对三网访问速度有要求的用户

## 选择建议

- **预算充裕、对稳定性要求高**：搬瓦工、DMIT
- **需要高防**：丽萨主机
- **低成本试水**：HostDare、ByteVirt
- **需要解锁 TikTok/ChatGPT**：六六云
- **建站 / 电商**：TmhHost

选择 VPS 本质是在延迟、稳定性、价格三者之间找平衡。

## Q&A

**Q：CN2 GIA 和普通 CN2 有什么区别？**
A：CN2 GT 是普通版，高峰期易拥堵；CN2 GIA 是精品版，全程高优先级，更稳定。很多标"CN2"的商家实际走的是 GT，购买前需确认。

**Q：这些商家支持支付宝吗？**
A：大部分支持，如搬瓦工、AkkoCloud、六六云、丽萨主机、TmhHost 等。

**Q：CN2 GIA VPS 适合做什么？**
A：常见场景包括代理、海外建站、远程办公等。需要流媒体解锁的关注原生 IP（DMIT、OneTechCloud、六六云）。

**Q：美国 CN2 GIA 和香港、日本怎么选？**
A：美国性价比最高，适合大多数场景。香港延迟最低但价格贵 2-3 倍。日本介于两者之间。

**Q：套餐流量不够怎么办？**
A：多数商家支持购买额外流量包或升级套餐。
