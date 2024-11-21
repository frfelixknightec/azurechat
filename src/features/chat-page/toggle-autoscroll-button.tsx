import { useChat } from "@/features/chat-page/chat-store";

export const ToggleAutoScrollButton: React.FC = () => {
  const chatState = useChat(); // Get reactive chat state

  const handleToggle = () => {
    chatState.toggleAutoScroll(); // Call the toggle method
  };

  return (
    <button
      onClick={handleToggle}
      className="border border-input bg-background hover:bg-accent hover:text-accent-foreground rounded px-3"
    >
      {chatState.autoScroll ? "Disable AutoScroll" : "Enable AutoScroll"}
    </button>
  );
};