import { LightningElement} from 'lwc';

export default class DateBind extends LightningElement {
    quote='Things are more like they are now than they have ever been before.';

    handleChange(event) {
        this.quote = event.target.value;
    }
}