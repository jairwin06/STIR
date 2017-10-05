<rouser-alarms>
<header class="header-bar">
    <div class="pull-left">
        <h1 class="title">STIR - Rouser</h1>
    </div>
</header>
<div class="content">
     <div show="{state.rouser.alarms != null}" class="padded-full">
           <div id="choice" class="row">
                Alarms in your queue:
            </div>
            <ul>
                <li each={ state.rouser.alarms }>
                    <a href="/rouser/alarm/{_id}/record">{name}</a>
                </li>
            </ul>
            <p show="{state.rouser.alarms && state.rouser.alarms.length == 0}">No alarms in queue</p>
      </div>
      <div show="{ state.rouser.alarms == null }" class="circle-progress center active">
        <div class="spinner"></div>
     </div>
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
    });

    this.on('unmount', () => {
    });

    this.on('ready', () => {
        this.update();
    });

    queueUpdated() {
        console.log("Queue updated");
        this.update();
    }

 </script>
</rouser-alarms>
