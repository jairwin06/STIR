<dashboard>
 <section id="admin-dashboard">
     <h1 class="title">Dashboard</h1>
     <table>
        <thead>
            <th>Name</th>
            <th>Time</th>
            <th>Assigned to</th>
            <th>Turk it</th>
        </thead>
        <tbody>
            <tr each={ state.admin.alarms }>
                <td>{name}</td>
                <td>{time}</td>
                <td>{mturk? "MTURK" : assignedTo}</td>
                <td><button click={parent.mturk}>Turk it</button></td>
            </tr>
        </tbody>
    </table>
    <b show"{error}" class="error">{error}</b>
 </section>

 <style>
  #admin #admin-dashboard  {
    h1 {
     color: black;
    }
    table, th, td {
       border: 1px solid black;
    }
  }
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
</dashboard>
