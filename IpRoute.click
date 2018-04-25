in :: FromDevice(ens33);
out :: Queue -> ToDevice(ens33);
in -> cl :: Classifier(12/0800, 12/0806 20/0001, 12/0806 20/0002);
aout :: ARPQuerier(192.168.3.136, 00:0c:29:e1:1f:18);

cl[2] -> Print("ARP replies") -> [1]aout

aout[0] -> out;
cl[1] -> 
  ARPResponder(192.168.3.136 00:0c:29:e1:1f:18) ->
  out;
cl[0] ->
  Strip(14) ->
  CheckIPHeader ->
  ic :: IPClassifier(ip proto icmp,-)
ic[0] ->
  MarkIPHeader() ->
  IPPrint("icmp") ->
  ICMPPingResponder() ->
  out;
ic[1] ->
  IPPrint("in") ->
  rw1 :: IPRewriter(pattern - - 192.168.3.137 - 0 1);
rw1[0] ->
  SetIPAddress(192.168.3.1) -> //我那个官地址
  aout;
rw1[1] ->
  SetIPAddress(192.168.3.1) -> //网关地址
  aout;