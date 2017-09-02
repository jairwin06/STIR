<alarm-queue>
 <div section id="alarm-queue">
     <h1 class="title">Alarm Queue</h1>
        <ul>
            <li each={ state.rouser.alarms }>
                <a href="/rouser/alarm/{_id}">{name}</a>
            </li>
        </ul>
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
        this.state.rouser.on('queue_updated', this.queueUpdated);
        this.update();
    });

    this.on('unmount', () => {
    });


    queueUpdated() {
        this.update();
    }

 </script>
</alarm-queue>
