<admin-dashboard>
  <header class="header-bar">
        <div class="pull-left">
            <h1 class="title">STIR - Admin</h1>
        </div>
  </header>
  <div class="content">
     <div class="padded-full">
         <table class="table">
            <thead>
                <th>Name</th>
                <th>Time</th>
                <th>Assigned to</th>
                <th>Recorded</th>
                <th>Delivered</th>
                <th>Turk it</th>
            </thead>
            <tbody>
                <tr each={ state.admin.alarms }>
                    <td>{name}</td>
                    <td>{time}</td>
                    <td>{mturk? "MTURK" : assignedTo}</td>
                    <td>{recording.finalized}</td>
                    <td>{delivered}</td>
                    <td><button click={parent.mturk}>Turk it</button></td>
                </tr>
            </tbody>
        </table>
     </div>
      <b show"{error}" class="error">{error}</b>
  </div>

 <style>
 </style>
 <script>
    this.on('mount', () => {
        console.log("admin dashboard mounted");
        this.state.admin.on('alarms_updated', this.onAlarmsUpdated);
    });

    this.on('unmount', () => {
        this.state.admin.off('alarms_updated', this.onAlarmsUpdated);
    });

    async mturk(e) {
        console.log("Send to MTurk!", e.item);
        try {
            let result = await this.state.admin.assignMTurk(e.item);
            console.log("Result: ", result);
            e.item.mturk = result.mturk;
            this.update();
        }
        catch (err) {
            console.log("MTurk error", err);
            this.error = err.message;
            this.update();
        }
    }

    onAlarmsUpdated() {
        this.update();
    }

 </script>
</admin-dashboard>
