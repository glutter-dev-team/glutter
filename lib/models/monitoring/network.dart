/// Represents the Network-Values from the Glances-API.
class Network {
    /// The name of the current network-interface.
    String interfaceName;

    /// Time passed by since last update.
    double timeSinceUpdate;

    /// Cumulative rate of network-traffic receive to the server. (bytes)
    int cumulativeReceive;

    /// Rate of network-traffic receive to the server.
    int receive;

    /// Cumulative rate of network-traffic send by the server. (bytes)
    int cumulativeTx;

    /// Rate of network-traffic send by the server.
    int tx;

    int cumulativeCx;

    int cx;

    /// Specifies whether the specifies network-interface is up (online)
    bool isUp;

    /// Specifies the speed of the current network-interface
    int speed;

    String key;

    /// Constructor for Network-Objects.
    Network(String interfaceName, double timeSinceUpdate, int cumulativeReceive, int receive, int cumulativeTx, int tx, int cumulativeCx, int cx, bool isUp, int speed, String key) {
        this.interfaceName = interfaceName;
        this.timeSinceUpdate = timeSinceUpdate;
        this.cumulativeReceive = cumulativeReceive;
        this.receive = receive;
        this.cumulativeTx = cumulativeTx;
        this.tx = tx;
        this.cumulativeCx = cumulativeCx;
        this.cx = cx;
        this.isUp = isUp;
        this.speed = speed;
        this.key = key;
    }

    /// For deserialization of JSON and conversion to Network-Object.
    factory Network.fromJson(dynamic json) {
        return Network(
            json['interface_name'] as String,
            double.parse(json['time_since_update'].toString()),
            json['cumulative_rx'] as int,
            json['rx'] as int,
            json['cumulative_tx'] as int,
            json['tx'] as int,
            json['cumulative_cx'] as int,
            json['cx'] as int,
            json['is_up'] as bool,
            json['speed'] as int,
            json['key'] as String
        );
    }
}