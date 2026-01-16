# ARCHITECTURE

Layers:
- UI (Widgets only)
- State (Provider/Riverpod-ready)
- Domain (Models, UseCases)
- Data (Repositories, Services)
- Platform (Channels – Android only)

Rules:
- UI never talks directly to platform
- Services are injected, not static
- Models are platform-agnostic
