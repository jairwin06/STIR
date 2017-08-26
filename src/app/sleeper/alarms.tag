<alarms>
 <h1 class="title">Current Alarms</h1>
 <style>
  #sleeper alarms {
    h1 {
     color: red;
    }
  }
 </style>
 <script>
    this.on('mount', () => {
        console.log("alarms mounted");
    });

    this.on('unmount', () => {
    });
 </script>
</alarms>
