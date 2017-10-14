<admin-dashboard>
  <header class="header-bar">
        <div class="pull-left">
            <h1 class="title">STIR - Admin</h1>
        </div>
  </header>
  <div class="content">
     <div class="padded-full" show="{state.admin.alarms != null}">
         <table class="table">
            <thead>
                <th>Name</th>
                <th>Time</th>
                <th>Analyzed</th>
                <th>Assigned to</th>
                <th>Recorded</th>
                <th>Delivered</th>
                <th>Recording</th>
                <th>Turk it</th>
            </thead>
            <tbody>
                <tr each={ state.admin.alarms }>
                    <td>{name}</td>
                    <td>{time}</td>
                    <td>{analyzed}</td>
                    <td>{mturk? "MTURK" : assignedTo}</td>
                    <td>{recording.finalized}</td>
                    <td>{delivered}</td>
                    <td>
                        <span if="{recording.mixUrl}">
                            <audio ref="preview" controls="controls">
                                <source src="{recording.mixUrl}"></source>
                            </audio>
                        </span>
                    <td>
                    <td><button class="btn primary" disabled={!analyzed} click={parent.mturk}>Turk it</button></td>
                </tr>
            </tbody>
        </table>
     </div>
      <div show="{ state.admin.alarms == null || loading }" class="circle-progress center active">
        <div class="spinner"></div>
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
            this.loading = true;
            this.update();
            let result = await this.state.admin.assignMTurk(e.item);
            this.loading = false;
            console.log("Result: ", result);
            e.item.mturk = result.mturk;
            this.update();
        }
        catch (err) {
            console.log("MTurk error", err);
            this.error = err.message;
            this.loading = false;
            this.update();
        }
    }

    onAlarmsUpdated() {
        this.update();
    }

 </script>
</admin-dashboard>
