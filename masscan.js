import fs from 'fs'
import { spawn  } from 'child_process'

function getTimestamp() {
  const now = new Date();
  // 转换为 UTC 毫秒数 + 8 小时
  const beijingTime = new Date(now.getTime() + 8 * 60 * 60 * 1000);

  const month = String(beijingTime.getMonth() + 1).padStart(2, '0');
  const day = String(beijingTime.getDate()).padStart(2, '0');
  const hour = String(beijingTime.getHours()).padStart(2, '0');
  const minute = String(beijingTime.getMinutes()).padStart(2, '0');

  return `${month}.${day}_${hour}.${minute}`;
}
async function masscan(){
let rate
let prefixes
const timestamp = getTimestamp();
const res=`results_${timestamp}.txt`
const args = process.argv.slice(1);
rate = args[1] || 6000
prefixes = args[2] || 'prefixes.txt'
await fs.promises.writeFile( res, 'utf-8');
// 读取 port.txt 并拼接为逗号分隔的字符串
const ports = fs.readFileSync('port.txt', 'utf-8')
  .split(/\r?\n/)             // 按行分割
  .filter(line => line.trim()) // 过滤空行
  .join(',');                 // 组合为 "80,443,8080" 格式


console.log('端口列表:', ports);
console.log('速率列表:', rate);
console.log('输出文件', res)
const masscan_args = [
  '--exclude', '255.255.255.255',
  '-p', ports,
  '--max-rate', rate,
  '-oG', res,
  '-iL', prefixes,

];

const masscan = spawn('masscan', masscan_args);

// 实时输出 stdout
masscan.stdout.on('data', data => {
  process.stdout.write(data);
});

// 实时输出 stderr
masscan.stderr.on('data', data => {
  process.stderr.write(`stderr: ${data}`);
});

masscan.on('close', code => {
  console.log(`Masscan 扫描完成，退出码 ${code}`);
});
}


masscan()