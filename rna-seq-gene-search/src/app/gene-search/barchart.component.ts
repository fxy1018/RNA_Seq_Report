import { Component, Input, OnInit } from '@angular/core';
import { Expression } from './expression';

declare var Plotly: any;

@Component({
  selector: 'barchart',
  templateUrl: './barchart.component.html',
//  styleUrls: ['./gene.component.css']
})
export class BarchartComponent implements OnInit {
  @Input() data: any;
	
	
	constructor(){};
	
	ngOnInit(): void {
		console.log('hello from barchart')
        console.log(this.data)
        this.data = [{
            x: ['giraffes', 'orangutans', 'monkeys'],
            y: [20, 14, 23],
            type: 'bar'
        }]
    Plotly.newPlot('barchart', this.data);
		
		
		
		
	};
	
}