import "./App.css";
import { useState } from "react";
import Viewer from "./Viewer";
import Controller from "./Controller";

function App() {
  const [count, setCount] = useState(10);
  const handleSetCount = (value) => {
    setCount(count + value);
  };
  return (
    <div className="App">
      <h1>Simple Counter</h1>
      <section>
        <Viewer count={count} />
      </section>
      <section>
        <Controller handleSetCount={handleSetCount} />
      </section>
    </div>
  );
}

export default App;
