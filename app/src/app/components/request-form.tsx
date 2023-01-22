export const RequestForm = () => {
  return (
    <form action="">
      <h2>Request Preimage</h2>
      <label htmlFor="preimage">Preimage: </label>
      <input
        id="#preimage"
        type="text"
        name="preimage"
        placeholder="8765456788976.."
      />
      <br />
      
      <label htmlFor="price">Price: </label>
      <input id="#price" type="text" name="price" placeholder="1eth" />
      <br />
      
      <button>Request</button>
    </form>
  );
};
