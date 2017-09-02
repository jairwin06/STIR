<alarm-queue>
 <div section id="alarm-queue">
     <h1 class="title">Alarm Queue</h1>
 </div>
 <style>
  #rouser #alarm-queue {
    h1 {
     color: purple;
    }
  }
 </style>
 <script>
    this.on('mount', () => {
        console.log("alarm-queue mounted");
    });

    this.on('unmount', () => {
    });


    queueUpdated() {
    }

 </script>
</alarm-queue>
