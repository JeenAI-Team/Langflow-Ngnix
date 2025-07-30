import React from "react";

export default function ForbiddenPage() {
  return (
    <div
      style={{
        position: "fixed",
        inset: 0,
        width: "100vw",
        height: "100vh",
        backgroundColor: "#0d0d0d",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        fontSize: "32px",
        fontFamily: "sans-serif",
        color: "#ffffff",
        zIndex: 9999,
      }}
    >
      403&nbsp;Forbidden
    </div>
  );
} 