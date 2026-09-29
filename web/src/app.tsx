import { Menu } from "./components/menu/menu";
import { ContextMenu } from "./components/context/context";

const App = () => {
  return (
    <div className="min-h-screen min-w-screen">
      <Menu />
      <ContextMenu />
    </div>
  );
};

export default App;
