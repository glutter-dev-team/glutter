class Memory {
  /// Total physical memory installed.
  double total;

  /// the actual amount of available memory that can be given instantly to processes that request
  /// more memory in bytes; this is calculated by summing different memory values depending on the platform
  /// (e.g. free + buffers + cached on Linux) and it is supposed to be used to monitor actual memory usage in a cross platform fashion.
  double available;

  /// The percentage usage calculated as (total-available)/total*100.
  double usagePercent;

  /// Memory used, calculated differently depending on the platform and designed for informational purposes only.
  double used;

  /// Memory not being used at all (zeroed) that is readily available; note that this doesn’t reflect the actual memory available (use ‘available’ instead).
  double free;

  /// UNIX: Memory currently in use or very recently used, and so it is in RAM.
  double active;

  /// UNIX: Memory that is marked as not used.
  double inactive;

  /// Linux, BSD: Cache for things like file system metadata.
  double buffers;

  /// Linux, BSD: Cache for various things.
  double cached;

  /// BSD: Memory that may be simultaneously accessed by multiple processes.
  double shared;

  /// BSD: Memory that may be simultaneously accessed by multiple processes.
  double wired;
}