import { Component, Input, OnInit, AfterViewInit } from '@angular/core';
import { Expression } from './expression';

export class Name{
	id: number;
	firstname: string;
	lastname: string;
	username: string;
}

const NAMES: Name[] =[
	{id:1, firstname:'Mark', lastname:'Otto', username:'@mdo'},
	{id:2, firstname:'Jacob', lastname:'Thornton	', username:'@fat'},
	{id:3, firstname:'Larry', lastname:'the Bird	', username:'@twitter'}
]



declare var Plotly: any;
declare var jQuery: any;
declare var $: any;

@Component({
    selector: 'data-table',
    templateUrl: './data-table.component.html',

})

export class DataTableComponent implements OnInit {
    @Input() data: any;
    // @Input() layout:any;
    // @Input() options: any;
    // @Input() displayRawData: boolean;

    // data = [{
    //     x: ['giraffes', 'orangutans', 'monkeys'],
    //     y: [20, 14, 23],
    //     type: 'bar'
    // }];

    // layout = {barmode:'group'};
    // options = null;
    // displayRawData = null;
		
		names: Name[];
	
    ngOnInit(): void{
				this.names = NAMES;
        console.log('hello from heatmap')
        console.log(this.data)
        $('#data_table_exp').DataTable({
					"data": NAMES,
					"columns": [
          {'data':'id'},
          {'data':'firstname'},
          {'data':'lastname'},
          {'data':'username'}]
				});


    };
    // ngAfterViewInit(){
    //     document.getElementById('data_table_exp').DataTable();
    // }


}