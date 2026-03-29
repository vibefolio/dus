import { Stack } from "expo-router";

export default function AuthLayout() {
  return (
    <Stack
      screenOptions={{
        headerShown: true,
        headerTitle: "",
        headerBackTitle: "뒤로",
        headerTintColor: "#00a859",
        headerStyle: { backgroundColor: "#F9FAFB" },
        headerShadowVisible: false,
      }}
    />
  );
}
