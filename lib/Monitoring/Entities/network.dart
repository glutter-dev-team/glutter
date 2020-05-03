class Network {
    String interfaceName;

    double timeSinceUpdate;

    double cumulativeReceive;

    double receive;

    double cumulativeTx;

    double tx;

    double cumulativeCx;

    double cx;

    bool isUp;

    double speed;

    String key;

    /// Constructor for Network-Objects.
    Network(String interfaceName, double timeSinceUpdate, double cumulativeReceive, double receive, double cumulativeTx, double tx, double cumulativeCx, double cx, bool isUp, double speed, String key) {
        this.interfaceName = interfaceName;
        this.timeSinceUpdate = timeSinceUpdate;
        this.cumulativeReceive = cumulativeReceive;
        this.receive = receive;
        this.cumulativeTx = cumulativeTx;
        this.cx = cx;
        this.isUp = isUp;
        this.speed = speed;
        this.key = key;
    }

    /// For deserialization of JSON and conversion to Network-Object.
    factory Network.fromJson(dynamic json) {
        return Network(
            json['interface_name'] as String,
            json['time_since_update'] as double,
            json['cumulative_rx'] as double,
            json['rx'] as double,
            json['cumulative_tx'] as double,
            json['tx'] as double,
            json['cumulative_cx'] as double,
            json['cx'] as double,
            json['is_up'] as bool,
            json['speed'] as double,
            json['key'] as String
        );
    }
}