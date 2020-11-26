  host = Net::Telnet::new({
           "Binmode"    => false,        # default: false
           "Host"       => "localhost",  # default: "localhost"
           "Output_log" => "output_log", # default: nil (no output)
           "Dump_log"   => "dump_log",   # default: nil (no output)
           "Port"       => 23,           # default: 23
           "Prompt"     => /[$%#>] \z/n, # default: /[$%#>] \z/n
           "Telnetmode" => true,         # default: true
           "Timeout"    => 10,           # default: 10
           # if ignore timeout then set "Timeout" to false.
           "Waittime"   => 0,            # default: 0
           "Proxy"      => proxy         # default: nil
                           # proxy is Telnet or TCPsocket object
         })
