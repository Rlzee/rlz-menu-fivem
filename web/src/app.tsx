import { Menu } from "./components/menu/menu";
import { ContextMenu } from "./components/context/context";
import { SearchBar } from "./components/search-bar";

const App = () => {
  return (
    <div className="min-h-screen min-w-screen">
      <Menu />
      <ContextMenu />
      <SearchBar />
    </div>
  );
};

export default App;
