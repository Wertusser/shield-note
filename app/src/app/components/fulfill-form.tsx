export const FulfillForm = () => {
  return (
    <form action="">
      <h2>Fulfill Order</h2>
      <label htmlFor="requestId">Request Id: </label>
      <input
        id="#requestId"
        type="text"
        name="requestId"
        placeholder="8765456788976.."
      />
      <br />
      
      <label htmlFor="witness">Witness: </label>
      <input id="#witness" type="text" name="witness" placeholder="1234.." />
      <br />
      
      <button>Fulfill</button>
    </form>
  );
};
