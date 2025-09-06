#!/bin/bash

echo "===== Server Performance Stats ====="

# CPU 使用率
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8"%"}')
echo "CPU 使用率：${cpu_usage}"

# 内存使用
read total used free <<< $(free -m | awk 'NR==2{printf "%s %s %s", $2,$3,$4}')
percent_mem=$(awk "BEGIN {printf \"%.2f\", $used/$total*100}")
echo "内存使用：${used}M / ${total}M (${percent_mem}%)"

# 磁盘使用
read used_d total_d <<< $(df -h / | awk 'NR==2{print $3, $2}')
percent_d=$(df / | awk 'NR==2{print $5}')
echo "磁盘使用：${used_d} / ${total_d} (${percent_d})"

# 前5 CPU高进程
echo "Top 5 CPU 占用进程："
ps aux --sort=-%cpu | head -n 6

# 前5 内存高进程
echo "Top 5 内存 占用进程："
ps aux --sort=-%mem | head -n 6

echo "=====  可选信息 ====="
# 系统版本
echo "系统版本：$(grep PRETTY_NAME /etc/os-release | cut -d'=' -f2 | tr -d '\"')"
# Uptime & Load
echo "系统运行时间及负载：$(uptime -p), 负载：$(uptime | awk -F 'load average:' '{print $2}')"
# 登录用户数
echo "当前登录用户数：$(who | wc -l)"
# 失败登录尝试
echo "失败登录尝试次数：$(grep -i 'failed password' /var/log/auth.log 2>/dev/null | wc -l)"

echo "===================================="
